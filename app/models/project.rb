require 'set'

# ============================================================================
# e-archia: project model
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class Project < ActiveRecord::Base
  # ==========================================================================
  # database relationships
  # ==========================================================================
  belongs_to :user
  
  # ==========================================================================
  # data validation
  # ==========================================================================
  validates_presence_of :title, :contents,
  :message => "não pode ser nulo"
  
  validates_length_of :title, 
                      :within     => 3..256,
                      :too_long   => "deve ter menos que %d caracteres",
                      :too_short  => "deve ter mais que %d caracteres"
  validates_length_of :subtitle, 
                      :within     => 3..256,
                      :too_long   => "deve ter menos que %d caracteres",
                      :too_short  => "deve ter mais que %d caracteres"
  validates_length_of :contents, 
                      :maximum => 2048,
                      :message => "deve ter menos que %d caracteres"

  # ==========================================================================
  # before_create filter
  # ==========================================================================
  def before_create
    @attributes['permalink'] = 
      title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z_]+/, '')
  end
  
  def file=(uploaded_file)  
     @uploaded_file = uploaded_file
     @filename = sanitize_filename(@uploaded_file.original_filename)
     self.filename = @filename
     raise "content type is not zip (#{@uploaded_file.content_type})" unless @uploaded_file.content_type == 'application/zip'
  end

   def after_create
     FileUtils.mkdir_p File.dirname(complete_path_to_file) unless File.exists? File.dirname(complete_path_to_file)
     
     if @uploaded_file.instance_of? Tempfile
       FileUtils.copy @uploaded_file.local_path, complete_path_to_file
     else
       File.open(self.complete_path_to_file, "wb") { |f| f.write(@uploaded_file.read) }
     end
     # unzip stuff and create text manifest with structure
     system "unzip #{complete_path_to_file} -d #{path_to_file}"

    system "cd #{path_to_file} && find . -print | sed -e 's;[^/]*/;-;g;s;____|; |;g' >> .tmp_dir_struct"
    
    f = File.new "#{path_to_file}/.tmp_dir_struct", 'r'
    f.readline
    
    tree = f.readlines.join
    
    File.delete "#{path_to_file}/.tmp_dir_struct"
    
    system "cd -"


     manifest = %(global_id: #{complete_path_to_file}
local_id: #{self.permalink}
owner: #{self.user_id}
titulo: #{self.title}
sub-titulo: #{self.subtitle}
acm-classification: tbd
autores: 
#{(self.authors.split "\n").map{|i| "-#{i}\n"}.join}orientadores: 
#{(self.supervisors.split "\n").map{|i| "-#{i}\n"}.join}ficheiros:
#{tree}
)

     # create the manifest
     fm = File.new "#{File.join path_to_file, 'MANIFEST.yml'}", 'w'
     #fm.encoding = Encoding::UTF8
     fm.write manifest.toutf8
     fm.close

     fl = File.new "#{File.join path_to_file, 'LICENSE.txt'}", 'w'
     #fl.encoding = Encoding::UTF8
     fl.write self.contents.toutf8
     fl.close

     File.delete complete_path_to_file
     
     system "cd #{path_to_file} && zip -r #{@filename} *"
     system "cd #{path_to_file} && zip -r relatorio relatorio"
     system "cd #{path_to_file} && zip -r apresentacao apresentacao"
     system "cd #{path_to_file} && zip -r codigo codigo"
     
     system "cd #{path_to_file}/apresentacao && ls >> .ls_apres"
     system "cd #{path_to_file}/relatorio && ls >> .ls_rel"
     
     files = []
     
     f = File.new "#{path_to_file}/apresentacao/.ls_apres", 'r'
     f.readlines.map(&:rstrip).each do |line|
      files << "#{path_to_file}/apresentacao/" + line if is_textual?(line)
     end
     f.close

     f = File.new "#{path_to_file}/relatorio/.ls_rel", 'r'
     f.readlines.map(&:rstrip).each do |line|
      files << "#{path_to_file}/relatorio/" + line if is_textual?(line)
     end
     f.close
     
    result = {}
    
    files.each do |fp|
      f = File.new fp
      contents = f.readlines.join
      debugger
      create_index remove_punctuation(contents), fp
      f.close
    end
   end

   def after_destroy
     system "rm -r #{path_to_file}"
   end

   def complete_path_to_file
     File.expand_path("#{RAILS_ROOT}/public/upload/#{id}-#{permalink}/#{@filename}")
   end

   def path_to_file
     File.expand_path("#{RAILS_ROOT}/public/upload/#{id}-#{permalink}/")
   end

   def is_textual?(filename)
     filename.include? 'txt' or filename.include? 'html'
   end

   def sanitize_filename(file_name)
     # get only the filename, not the whole path (from IE)
     just_filename = File.basename(file_name) 
     # replace all none alphanumeric, underscore or perioids with underscore
     just_filename.gsub(/[^\w\.\_]/,'_') 
   end
  

  def to_param
    "#{id}-#{permalink}"
  end

  def create_index(contents,filepath)
    h = {}
    
    contents.each { |l| l.split.each { |w| w.downcase!; w.size > 2 and h[w].nil? ? h[w] = 1 : h[w] = h[w] + 1 } }
    
    debugger
    h.each_pair do |key, value| 
      Word.create(:word => key, :filepath => filepath, :weight => value)
    end
  end
  
  def remove_punctuation(contents)
    contents.map { |c| c.gsub(/[^a-zA-Z ]/, ' ') }
  end

  def self.find_all(phrase)
    not_list = []
    and_list = []
    
    phrase.split.each do |w| 
      if w.starts_with?('-')
         not_list << Word.find_all_that_contain(w.gsub('-','').downcase)
      else 
         and_list << Word.find_all_that_contain(w.downcase)
      end
    end
    
    sort_results and_list, not_list
  end

  private
  
  def self.sort_results(and_list,not_list)
    not_ids = not_list.map { |e| e.first }.flatten
    
    # codigo adaptado do blog de miguelregedor.com
    x = and_list.map {|a| a.map {|a| a.first } }
    contagem = {}
    x.flatten.each { |e| contagem[e].nil? ? contagem[e] = 1 : contagem[e] = contagem[e] + 1 }
    
    lh = []
    ll = []
    
    contagem.each_pair { |k,v| v == and_list.size ? lh << [k,v] : ll << [k,v] }
    
    ordenacao_high = lh.sort_by { |a| a[1] }.reverse.map {|x,v| x}
    ordenacao_low  = ll.sort_by { |a| a[1] }.reverse.map {|x,v| x}
    
    resultado = (ordenacao_high + ordenacao_low).select { |e| !not_ids.member? e }
  end


end

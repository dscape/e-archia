xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "e-archia"
    xml.description "Últimos artigos do e-archia"
    xml.link formatted_stories_url(:rss)

    for story in @stories
      xml.item do
        xml.title story.title
        xml.description story.contents
        xml.pubDate story.created_at.to_s(:rfc822)
        xml.link formatted_story_url(story, :rss)
        xml.guid formatted_story_url(story, :rss)
      end
    end
  end
end
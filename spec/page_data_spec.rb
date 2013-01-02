require 'hacker_term/page_data'

module HackerTerm
  describe PageData do
    describe 'replace missing nodes and format numbers' do
      before(:each) do
        @data = 
        '{"items":[
          {
           "title":"NextId",
           "url":"/news2",
           "description":"hn next id news2 "
          },
          {
           "title":"Ray Kurzweil joins Google",
           "url":"http://www.kurzweilai.net/kurzweil-joins-google-to-work-on-new-projects-involving-machine-learning-and-language-processing?utm_source=twitterfeed&utm_medium=twitter",
           "score":"260 points",
           "user":"dumitrue",
           "comments":"122 comments",
           "time":"14 hours ago",
           "item_id":"4923914",
           "description":"260 points by dumitrue 14 hours ago  | 122 comments"
          }
        ]}'
        @pd = PageData.new @data
      end

      it 'adds score node' do
        @pd.data.first.should have_key 'score'
      end

      it 'adds comments node' do
        @pd.data.first.should have_key 'comments'
      end

      it 'formats score node as a number when the node didn\'t exist' do
        @pd.data.first['score'].should == '0'
      end

      it 'formats score node as a number when text is present' do
        @pd.data.last['score'].should == '260'
      end

      it 'formats comments node as a number when the node didn\'t exist' do
        @pd.data.first['comments'].should == '0'
      end

      it 'formats comments node as a number when text is present' do
        @pd.data.last['comments'].should == '122'
      end

    end

    describe 'format urls' do
      before :each do 
        @data = 
        '{"items":[
          {
            "title": "Ask HN: Who is hiring? (January 2013)",
            "url": "item?id=4992617",
            "score": "175 points",
            "user": "whoishiring",
            "comments": "140 comments",
            "time": "11 hours ago",
            "item_id": "4992617",
            "description": "175 points points by whoishiring 11 hours ago | 140 comments"
          }
        ]}'
        @pd = PageData.new @data
      end

      it 'link to HN if url is not external' do
        @pd.data.first['url'].should == 'http://news.ycombinator.com/item?id=4992617'
      end
    end

    describe 'calculating stats' do
      before(:each) do
        @page_data = HackerTerm::PageData.new File.read './data/data.json' 
      end

      it 'provides a mean' do
        @page_data.mean_score.should == 194.19354838709677
      end

      it 'provides a median' do
        @page_data.median_score.should == 131
      end

      it 'provides a mode' do
        @page_data.mode_score.should == 0
      end
    end

    describe 'sorting' do
      before(:each) do
        @data = 
        '{"items":[
          {
           "title":"First Article",
           "url":"http://google.com",
           "score":"0 points",
           "user":"dumitrue",
           "comments":"100 comments",
           "time":"14 hours ago",
           "item_id":"4923914",
           "description":"260 points by dumitrue 14 hours ago  | 122 comments"
          },
          {
          "title":"Second Article",
           "url":"http://google.com",
           "score":"50 points",
           "user":"dumitrue",
           "comments":"5 comments",
           "time":"14 hours ago",
           "item_id":"4923914",
           "description":"260 points by dumitrue 14 hours ago  | 122 comments"
          },
          {
           "title":"Third Article",
           "url":"http://google.com",
           "score":"25 points",
           "user":"dumitrue",
           "comments":"0 comments",
           "time":"14 hours ago",
           "item_id":"4923914",
           "description":"260 points by dumitrue 14 hours ago  | 122 comments"
          }
        ]}'
        @pd = PageData.new @data
      end

      it 'preserves natural ordering as default' do
        @pd.data.first['title'].should == 'First Article'
        @pd.data.last['title'].should == 'Third Article'
      end

      it 'sorts by score when requested' do
        @pd.sort_on!(:score)
        @pd.data.first['title'].should == 'Second Article'
        @pd.data.last['title'].should == 'First Article'
      end

      it 'sorts by number of comments when requested' do
        @pd.sort_on!(:comments)
        @pd.data.first['title'].should == 'First Article'
        @pd.data.last['title'].should == 'Third Article'
      end

      it 'sorts by rank when requested' do
        @pd.sort_on!(:rank)
        @pd.data.first['title'].should == 'First Article'
        @pd.data.last['title'].should == 'Third Article'
      end

      it 'sorts by title when requested' do
        @pd.sort_on!(:title)
        @pd.data.first['title'].should == 'First Article'
        @pd.data.last['title'].should == 'Third Article'
      end

      it 're-sorts by rank when requested' do
        @pd.sort_on!(:comments)
        @pd.sort_on!(:rank)
        @pd.data.first['title'].should == 'First Article'
        @pd.data.last['title'].should == 'Third Article'
      end
    end
  end
end

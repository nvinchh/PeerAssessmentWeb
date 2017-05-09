class Nlp
  require 'uri'
  require 'json'
  require 'net/http'

  def self.generate_tile_chart(task_ids)
    sentiments = generate_sentiments(task_ids)
#    return JSON.parse(sentiments)["sentiments"]
    grouped_sentiments = JSON.parse(sentiments)["sentiments"].group_by{ |sentiment| sentiment["id"] }
    data = {
        "v_labels": grouped_sentiments.keys,
        "h_labels": ["Submission 1", "Submission 2", "Submission 3", "Submission 4", "Submission 5", "Submission 6", "Submission 7", "Submission 8"],
        "showTextInsideBoxes": true,
        "showCustomColorScheme": false,
        "tooltipColorScheme": "black",
        "font-size": 11,
        "font-face": "Arial",
        "custom_color_scheme": {
            "minimum_value": -1,
            "maximum_value": 1,
            "minimum_color": "#FFFF00",
            "maximum_color": "#FF0000",
            "total_intervals": 5
        },
        "color_scheme": {
          "ranges": [{
                       "minimum": -1,
                       "maximum": -0.5,
                       "color": "#E74C3C"
                     },
                     {
                      "minimum": -0.5,
                      "maximum": 0,
                      "color": "#F1948A"
                     },
                     {
                     "minimum": 0,
                     "maximum": 0.5,
                     "color": "#82E0AA"
                     },
                     {
                      "minimum": 0.5,
                      "maximum": 1,
                      "color": "#229954"
                     }]

        },
        "content": grouped_sentiments.values.map{|grouped_sentiment| grouped_sentiment.map{|sentiment| { text: sentiment["text"], value: sentiment["sentiment"]}}}
    }


    url = URI.parse('http://peerlogic.csc.ncsu.edu/reviewsentiment/configure')
    headers = {"Content-Type" => "application/json"}
    http = Net::HTTP.new(url.host,url.port)
    response = http.post(url.path, data.to_json, headers)
    tile_chart_url = JSON.parse(response.body)["url"]
    #
    # response = http.get(tile_chart_url)
    # response.body
  end

  private

  def self.generate_sentiments(task_ids)
    answers = Answer.where('create_in_task_id = ? and comment != ?', task_ids, 'null')
    reviews_data = { reviews: []}
    answers.each do | answer |
      reviews_data[:reviews] << { id: answer.assessor_actor_id, text: answer.comment}
    end

    url = URI.parse('http://peerlogic.csc.ncsu.edu/sentiment/analyze_reviews_bulk')
    headers = {"Content-Type" => "application/json"}
    http = Net::HTTP.new(url.host,url.port)
    response = http.post(url.path,reviews_data.to_json,headers)

    response.body
  end
end
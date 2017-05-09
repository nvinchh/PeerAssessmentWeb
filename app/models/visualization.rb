class Visualization
  def self.generate_topology(task_ids)

    category_hash = { 'student': 0, 'Student': 0, 'instructor': 1, 'ta': 1, 'admin': 1, 'submission': 2, 'review': 3}

    tasks = Task.all.where(id: task_ids).where('task_type = ? OR task_type = ?','review','submission').pluck(:id, :task_type, :course_title)
    task_nodes = tasks.map{ |task| {name: task[0], category: category_hash[task[1].to_sym], value: 3}}.flatten

    answers = Answer.where(create_in_task_id: task_ids).group(:assessee_actor_id, :assessor_actor_id, :create_in_task_id).pluck(:assessee_actor_id, :assessor_actor_id, :create_in_task_id)
    actor_ids = (answers.map{|ans| ans[0]} + answers.map{|ans| ans[1]}).uniq
    actors = Actor.where(id: actor_ids).pluck(:id, :role)
    actor_nodes = actors.map{ |actor| { name: actor[0], category: category_hash[actor[1].to_sym], value: 1} }.flatten

    node_hash = {}

    nodes = []
    links = []
    node_count = 0
    task_nodes.each do |task|
      node_hash["task"+task[:name]] = node_count
      nodes << task
      node_count = node_count + 1
    end
    actor_nodes.each do |actor|
      node_hash["actor"+actor[:name]] = node_count
      nodes << actor
      node_count = node_count + 1
    end

    answers.each do |ans|
      links << { source: node_hash["task"+ans[2]], target: node_hash["actor"+ans[0]]}
      links << { source: node_hash["task"+ans[2]], target: node_hash["actor"+ans[1]]}
    end


    {
        "type": "force",
        "categories": [
            {
                "name": "Student",
                "keyword": {},
                "base": "HTMLElement",
                "itemStyle": {
                    "normal": {
                        "brushType": "both",
                        "color": "#D0D102",
                        "strokeColor": "#5182ab",
                        "lineWidth": 1
                    }
                }
            },
            {
                "name": "Instructor",
                "keyword": {},
                "base": "WebGLRenderingContext",
                "itemStyle": {
                    "normal": {
                        "brushType": "both",
                        "color": "#00A1CB",
                        "strokeColor": "#5182ab",
                        "lineWidth": 1
                    }
                }
            },
            {
                "name": "Submissions",
                "keyword": {},
                "base": "SVGElement",
                "itemStyle": {
                    "normal": {
                        "brushType": "both",
                        "color": "#dda0dd",
                        "strokeColor": "#5182ab",
                        "lineWidth": 1
                    }
                }
            },
            {
                "name": "Reviews",
                "keyword": {},
                "base": "CSSRule",
                "itemStyle": {
                    "normal": {
                        "brushType": "both",
                        "color": "#61AE24",
                        "strokeColor": "#5182ab",
                        "lineWidth": 1
                    }
                }
            }
        ],
        "nodes": nodes,
        "links": links.uniq
    }
  end
end
class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
    def self.generate_topology

        category_hash = { 'student': 0, 'Student': 0, 'instructor': 1, 'ta': 1, 'admin': 1, 'submission': 2, 'review': 3}
        actors = Actor.all.pluck(:id, :role)
        tasks = Task.all.where('task_type = ? OR task_type = ?','review','submission').pluck(:id, :task_type, :course_title)
        task_nodes = tasks.map{ |task| {id: task[0], name: task[2], category: category_hash[task[1]], value: 1}}.flatten
        actor_nodes = actors.map{ |actor| { id: actor[0], name: actor[1], category: category_hash[actor[1]], value: 1} }.flatten

        answers = Answer.group(:assessee_actor_id, :assessor_actor_id, :create_in_task_id).pluck(:assessee_actor_id, :assessor_actor_id, :create_in_task_id)
        node_hash = {}
        links_hash = {}
        nodes = []
        links = []
        node_count = 0
        task_nodes.each do |task|
            node_hash["task"+task[:id]] = count
            nodes << task
            node_count = node_count + 1
        end
        actor_nodes.each do |actor|
            node_hash["actor"+actor[:id]] = count
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
            "links": links
        }
    end
end

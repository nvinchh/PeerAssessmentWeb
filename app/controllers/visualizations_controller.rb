class VisualizationsController < ApplicationController
  def topology
    @datawarehouse_entity_topology = User.generate_topology()
  end
end
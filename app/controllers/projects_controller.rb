class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
  end

  def update
    project = Project.find(params[:id])
    contestant = Contestant.find(params[:add_contestant])
    project.contestants << contestant
    redirect_to "/projects/#{project.id}"
  end
end
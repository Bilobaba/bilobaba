class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
  end

  def index_pros
      @members = Member.with_role(ROLE_PROFESSIONAL).order(pseudo: :asc)
      @h1_title = 'Les proposants'
      render :index
  end

  def index_amateurs
      @members = Member.with_role(ROLE_AMATEUR).order(pseudo: :asc)
      @h1_title = 'Les participants'
      render :index
  end

  def show
    @h1_title = @member.first_name.to_s.capitalize + ' ' + @member.name.to_s.upcase
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end
end

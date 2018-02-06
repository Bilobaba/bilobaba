class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
    if params.permit('pro')['pro'] == '1'
      @members = Member.with_role(:professional).order(pseudo: :asc)
      @h1_title = 'Les biloprocools'
    else
      @members = Member.without_role(:professional).order(pseudo: :asc)
      @h1_title = 'Les bilobabacools'
    end
  end

  def index_pros
      @members = Member.with_role(:professional).order(pseudo: :asc)
      @h1_title = 'Les biloprocools'
      render :index
  end

  def index_members
      @members = Member.without_role(:professional).order(pseudo: :asc)
      @h1_title = 'Les bilobabacools'
      render :index
  end

  def show
    @h1_title = 'Page bilobabacool'
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end
end

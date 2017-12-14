class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
    if params.permit('pro')['pro'] == '1'
      @members = Member.with_role(:professional).order(pseudo: :asc)
      @title = 'PROFESSIONNELS'
    else
      @members = Member.without_role(:professional).order(pseudo: :asc)
      @title = 'MEMBRES'
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end
end

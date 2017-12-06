class MembersController < ApplicationController
  before_action :set_member, only: [:show]

  def index
    @members = Member.with_role :professional
  end

  private
  def set_member
    @member = Member.find(params[:id])
  end
end

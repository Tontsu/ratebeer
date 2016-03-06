class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    #if not Membership.all.map(&:user_id).include? current_user.id
      @membership = Membership.new(membership_params)
      @membership.user = current_user

    respond_to do |format|
      if not current_user.nil? and @membership.save
        format.html { redirect_to @membership.beer_club, notice: "#{@membership.user.username}, welcome to the club!" }
        format.json { render :show, status: :created, location: @membership }
      else
        #format.html { render :new }
        format.html { redirect_to @membership, notice: 'Already a member' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }

      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    club_name = @membership.beer_club.name
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{club_name} ended" }
      format.json { head :no_content }
    end
  end

  def confirm_user
    membership = Membership.find(params[:id])
    if Membership.find_by(beer_club_id: membership.beer_club_id, user_id: current_user.id, confirmed: true)
      membership.update_attribute :confirmed, (true)
      redirect_to :back, notice:"membership confirmed"
    else
      redirect_to :back, notice:"membership not confirmed"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end

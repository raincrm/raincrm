class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :authorize_deal, only: [:show, :edit, :update, :destroy, :update_status]

  def index
    @deals = policy_scope(Deal).includes(:contact, :loan_officer)
    @deals = @deals.by_status(params[:status]) if params[:status].present?
  end

  def kanban
    deals = policy_scope(Deal).includes(:contact, :loan_officer)
    
    # Create stages matching your Figma design
    @stages = [
      {
        name: "Lead",
        status_key: "lead",
        deals: deals.where(status: ['lead', 'contact_made'])
      },
      {
        name: "Pre-Approval", 
        status_key: "pre_approval",
        deals: deals.where(status: ['diagnostics', 'online_application', 'credit_check', 'pre_approval'])
      },
      {
        name: "Under Contract",
        status_key: "under_contract",
        deals: deals.where(status: ['under_contract', 'processing'])
      },
      {
        name: "Closing",
        status_key: "closing",
        deals: deals.where(status: ['underwriting', 'final_docs', 'closing', 'closed'])
      }
    ]
  end

  def show
    @messages = @deal.messages.recent.includes(:user)
    @documents = @deal.documents.recent
    @status_options = Deal::STATUS_OPTIONS
  end

  def new
    @deal = Deal.new
    @contacts = policy_scope(Contact)
    @loan_officers = User.loan_officers
  end

  def create
    @deal = Deal.new(deal_params)
    @deal.loan_officer = current_user unless current_user.admin?
    
    if @deal.save
      create_status_message("Deal created")
      redirect_to @deal, notice: 'Deal was successfully created.'
    else
      @contacts = policy_scope(Contact)
      @loan_officers = User.loan_officers
      render :new
    end
  end

  def edit
    @contacts = policy_scope(Contact)
    @loan_officers = User.loan_officers
  end

  def update
    if @deal.update(deal_params)
      redirect_to @deal, notice: 'Deal was successfully updated.'
    else
      @contacts = policy_scope(Contact)
      @loan_officers = User.loan_officers
      render :edit
    end
  end

  def update_status
    old_status = @deal.status
    if @deal.update(deal_params.slice(:status))
      create_status_message("Status updated from #{old_status} to #{@deal.status}")
      
      respond_to do |format|
        format.html { redirect_to @deal, notice: 'Deal status was successfully updated.' }
        format.json { 
          render json: { 
            success: true, 
            deal: {
              id: @deal.id,
              status: @deal.status,
              status_display: Deal::STATUS_OPTIONS[@deal.status]
            }
          }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to @deal, alert: 'Failed to update deal status.' }
        format.json { render json: { success: false, errors: @deal.errors } }
      end
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_url, notice: 'Deal was successfully deleted.'
  end

  private

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def authorize_deal
    authorize @deal
  end

  def deal_params
    params.require(:deal).permit(:title, :deal_type, :status, :purchase_price, 
                                 :loan_amount, :contact_id, :loan_officer_id,
                                 :estimated_close_date, :notes)
  ends

  def policy_scope(scope)
    if current_user.admin?
      scope.all
    elsif current_user.loan_officer?
      scope.where(user: current_user)
    else
      scope.none
    end
  end

  def create_status_message(content)
    @deal.messages.create!(
      user: current_user,
      content: content,
      message_type: 'status_update'
    )
  end
end

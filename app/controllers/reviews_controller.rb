class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  before_action :ensure_current_user_is_owner, only: [:destroy, :update, :edit]
  before_action :ensure_user_is_authorized, only: [:show]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
    authorize @review
  end

  # GET /reviews/new
  def new
    @review = Review.new
    @review.product_id = params[:product_id] if params[:product_id]
    @review.product_name = params[:product_name] if params[:product_name]
    @review.published = true
  end

  # GET /reviews/1/edit
  def edit
    @review.product_name = params[:product_name] if params[:product_name]
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    # @review.image = params

    @review.owner_id = current_user.id
    @review.published = true

    respond_to do |format|
      if @review.save
        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    if current_user == @review.owner
      @review.destroy

      respond_to do |format|
        format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_back(fallback_location: root_url, notice: "Nice try, but that is not your review.")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:owner_id, :product_id, :rating, :would_repurchase, :body, :visibility, :published, :image)
    end

    # seems like this could be handled in a review policy

  # Authorization
    def ensure_current_user_is_owner
      if current_user != @review.owner
        redirect_back fallback_location: root_url, alert: "You're not authorized for that."
      end
    end

# Not needed when 'include Pundit' is in the app controller
    def ensure_user_is_authorized
      if !ReviewPolicy.new(current_user, @review).show?
        raise Pundit::NotAuthorizedError, "not allowed"
      end
    end

    # REMOVE COMMENTED OUT CODE
    # def ensure_user_is_authorized
    #   authorize @review
    # rescue Pundit::NotAuthorizedError
    #   flash[:alert] = "You are not authorized to view this review."
    #   redirect_to root_url
    # end
end

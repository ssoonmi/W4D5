class GoalsController <ApplicationController
  before_action :ensure_logged_in

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to user_url(@goal.user_id)
    else
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(@goal.user_id)
    end
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    if @goal && @goal.update(goal_params) && ensure_current_user(@goal.user_id)
      redirect_to user_url(@goal.user_id)
    else
      redirect_to user_url(@goal.user_id)
    end
  end

  def destroy
    @goal = Goal.find_by(id: params[:id])
    @goal.user_id = current_user.id
    if @goal && @goal.destroy && ensure_current_user(@goal.user_id)
      redirect_to user_url(@goal.user_id)
    else
      redirect_to user_url(@goal.user_id)
    end
  end

  private

  def ensure_current_user(user_id)
    current_user.id == user_id
  end

  def goal_params
    params.require(:goal).permit(:title, :description, :public)
  end


end

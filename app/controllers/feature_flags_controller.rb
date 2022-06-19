class FeatureFlagsController < ApplicationController

  before_action :load_object, only: %i[show edit update destroy edit_properties update_properties]
  before_action :load_parent, only: %i[create]
  before_action :build_params, :permit_params, only: %i[create update]
  before_action :load_environment, only: %i[edit_properties update_properties]

  def new
    @feature_flag = FeatureFlag.new
    render partial: 'new_edit', local: { action: 'new' }
  end

  def create
    feature_flag = @parent.feature_flags.new(params[:feature_flag])
    if feature_flag.save
      redirect_to_back project_path(@parent.uuid)
    else
      flash[:title] = 'Create Flag error'
      flash[:messages] = feature_flag.errors.full_messages.to_sentence
      redirect_to_back project_path(@parent.uuid)
    end
  end

  def edit
    render partial: 'new_edit', local: { action: 'edit' }
  end

  def show
    render partial: 'show'
  end

  def update
    params[:feature_flag].delete(:key)
    if @feature_flag.update(params[:feature_flag])
      redirect_to_back project_path(@parent.uuid)
    else
      flash[:title] = 'Update Flag error'
      flash[:messages] = @feature_flag.errors.full_messages.to_sentence
      redirect_to_back project_path(@parent.uuid)
    end
  end
  
  def edit_properties
    env_config = @environment.environment_configs.where(feature_flag_id: params[:id]).first
    env_config = env_config.present? ? env_config.configs : { state: :off }
    render partial: 'edit_properties', locals: { environment_id: params[:environment_id], env_config: env_config }
  end

  def update_properties
    env_config = @environment.environment_configs.where(feature_flag_id: params[:id]).first_or_create
    env_config[:configs] ||= {}
    env_config[:configs][:state] = case params[:feature_action]
        when 'enable'
          :on
        when 'disable'
          :off
        else
          nil
        end
    env_config.save
    ws_broadcast(@environment.client_id, env_config)
    head :no_content
  end

  def destroy
    @feature_flag.deleted = true
    @feature_flag.save
    # Redirect to current path
    redirect_to_back project_path(@parent.uuid)
  end

  private

  def load_parent
    @parent ||= current_account.projects.find_by(uuid: params[:project_id])
    raise ActiveRecord::RecordNotFound unless @parent
    @parent
  end

  def load_object
    load_parent
    @feature_flag ||= @parent.feature_flags.find(params[:id]) if params[:id]
  end

  def load_environment
    @environment ||= @parent.environments.find(params[:environment_id]) if params[:environment_id]
  end

  def permit_params
    params.require(:feature_flag).permit!
  end

  def build_params
    params[:feature_flag][:default_choices] = { on: params['on-select'], off: params['off-select'] }
  end
end
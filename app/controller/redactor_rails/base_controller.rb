class RedactorRails::BaseController < ApplicationController

  def index
    @redactors = controller_model.order :id
    render json: @redactors.to_json
  end

  def create
    @redactor = controller_model.new

    file = params[:file]
    @redactor.data = RedactorRails::Http.normalize_param(file, request)
    if current_user.present?
      @redactor.user_id = current_user.id
    end

    if @redactor.save
      render text: { filelink: @redactor.url }.to_json
    else
      render nothing: true
    end
  end

  protected

  def controller_model
    model_name(self.class.to_s.sub('Controller', '').singularize).constantize
  end

  def model_name(name)
    name == "RedactorRails::Document" ? "RedactorRails::Attachment" : name
  end

end

class Dashboard::ExportTasksController < Dashboard::BaseController
  def index
  end

  def create
    @category = @space.categories.where(:urlname => params[:export_task][:category_id]).first

    task = ExportTask.create(
      :space    => @space,
      :category => @category,
      :format   => params[:export_task][:format],
      :user     => current_user
    )
    ExportTask.delay.perform_task(task.id.to_s)

    redirect_to :action => :show, :id => task
  end

  def show
    @export_task = @space.export_tasks.find params[:id]
  end

  def download
    @export_task = @space.export_tasks.success.find params[:id]
    send_file @export_task.path, :filename => @export_task.filename
  end
end

class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:edit, :new, :update, :destroy]
  layout false, only: [:login]

  def login
    if current_employee
      redirect_to categories_path
    else
      render :login
    end
  end

  def logout
    session[:employee_id]=nil
    redirect_to categories_path
  end

  # DOES AN ACTUAL LOGIN
  def login_post
    @employee = Employee.find_by({email: params[:email]})
    if @employee
      if @employee.authenticate(params[:password])
        session[:employee_id] = @employee.id
        redirect_to categories_path
      else
        redirect_to '/login'
      end
    else
      redirect_to '/login'
    end
  end

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
   end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def require_login
    redirect_to '/login' unless current_employee
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name, :email, :phone_number, :password)
    end
  end

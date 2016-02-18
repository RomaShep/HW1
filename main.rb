class Developer
  attr_reader :name, :MAX_TASKS, :task_array

  def initialize(name)
    @name = name
    @MAX_TASKS = 10
    @task_array = []
  end

  def add_task (task_name)
    return raise "Слишком много работы!" if @task_array.count == @MAX_TASKS
    @task_array << task_name
    puts %Q{#{@name}: добавлена задача "#{task_name}". Всего в списке задач: #{@task_array.count}}
  end

  def tasks
    return "#{@name}: задач нет!" if @task_array.count == 0
    @s = ""
    @task_array.each_index{ |i| @s += "#{i+1}.#{@task_array[i]}\n" } 
    return @s
  end

  def work!
    return raise "Нечего делать!" if @task_array.count == 0
    puts %Q{#{@name}: выполнена задача "#{@task_array.shift}". Осталось задач: #{@task_array.count}}
  end

  def status
    case @task_array.count
      when 0   
        return "Свободен"
      when @MAX_TASKS  
        return "Занят"
      else     
        return "Работаю"
    end
  end

  def can_add_task?
    puts @task_array.count < @MAX_TASKS
  end

  def can_work?
    puts @task_array.count > 0
  end 
end

class JuniorDeveloper < Developer
    def initialize(name)
      super
      @MAX_TASKS = 5
  end

  def add_task (task_name)
    return raise "Слишком сложно!" if task_name.length >= 20
    super
  end

  def work!
    return raise "Нечего делать!" if @task_array.count == 0
    puts "#{@name}: пытаюсь делать задачу '#{@task_array.shift}'. Осталось задач: #{@task_array.count}"
  end
end

class SeniorDeveloper < Developer
  def initialize(name)
    super
    @MAX_TASKS = 15
  end

  def work!
    return raise "Нечего делать!" if @task_array.count == 0
    if [true,false].sample 
      2.times{ puts "#{@name}: выполнена задача '#{@task_array.delete(@task_array.sample)}'. Осталось задач: #{@task_array.count}"} if @task_array.count >=2
      super if @task_array.count == 1 
    else
      puts "#{@name}: Что-то лень!"
    end
  end
end

#dev = SeniorDeveloper.new('Sen')
#p dev
#dev.status
#dev.add_task("a")
#dev.add_task("b")
#dev.add_task("d")
#dev.add_task("c")
#dev.work!
#puts dev.tasks


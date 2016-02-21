class Developer
  attr_reader :name, :MAX_TASKS, :task_array

  def initialize(name)
    @name = name
    @MAX_TASKS = 10
    @task_array = []
  end

  def add_task (task_name)
    raise "Слишком много работы!" unless can_add_task?
    @task_array << task_name
    puts %Q{#{@name}: добавлена задача "#{task_name}". Всего в списке задач: #{@task_array.count}}
  end

  def tasks
    return "#{@name}: задач нет!" unless can_work?
    @task_array.map.with_index{ |x,i| "#{i+1}.#{x}\n" }.join("")
  end

  def work!
    check_work
    puts %Q{#{@name}: выполнена задача "#{@task_array.shift}". Осталось задач: #{@task_array.count}}
  end

  def check_work
    raise "Нечего делать!" unless can_work?
  end

  def status
    return "Свободен" unless can_work?
    return "Занят" unless can_add_task?
    "Работаю"
  end

  def can_add_task?
    @task_array.count < @MAX_TASKS
  end

  def can_work?
    !@task_array.empty?
  end 
end

class JuniorDeveloper < Developer
  self.class::MAX_TASKS = 5

  def add_task (task_name)
    raise "Слишком сложно!" if task_name.length >= 20
    super
  end

  def work!
    check_work
    puts %Q{#{@name}: пытаюсь делать задачу '#{@task_array.shift}'. Осталось задач: #{@task_array.count}}
  end
end

class SeniorDeveloper < Developer
  self.class::MAX_TASKS = 15

  def work!
    check_work
    if [true,false].sample
      if @task_array.count == 1
        super
      else
        2.times{ puts %Q{#{@name}: выполнена задача "#{@task_array.delete(@task_array.sample)}". Осталось задач: #{@task_array.count}}}
        #2.times{ super }
      end 
    else
      puts "#{@name}: Что-то лень!"
    end
  end
end


# dev = SeniorDeveloper.new('Sen')
# p dev
# puts dev.status
# dev.add_task("a")
# dev.add_task("b")
# dev.add_task("d")
# dev.add_task("c")
# puts dev.can_add_task?
# puts dev.can_work?
# dev.work!
# puts dev.tasks



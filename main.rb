class Developer
  attr_reader :name, :MAX_TASKS, :task_array, :TYPE, :STYPE
  attr_accessor :priority 

  def initialize(name)
    @name = name
    @MAX_TASKS = 10
    @task_array = []
    @TYPE = :developers
    @STYPE = 'developer'
    @priority = 0
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
  def initialize(name)
     super
     @MAX_TASKS = 5
     @TYPE = :juniors
     @STYPE = 'junior'
  end

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
  def initialize(name)
     super
     @MAX_TASKS = 15
     @TYPE = :seniors
     @STYPE = 'senior'
  end

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

class Team
  attr_accessor :seniors, :developers, :juniors
  attr_accessor :prior, :team

  def initialize
    @team = []  
    @prior = []                    
  end                               
    
  def have_seniors(*dev_name)
    dev_name.map{ |name| @team << SeniorDeveloper.new(name)}
  end
  def have_developers(*dev_name)
    dev_name.map{ |name| @team << Developer.new(name)}
  end
  def have_juniors(*dev_name)
    dev_name.map{ |name| @team << JuniorDeveloper.new(name)}
  end
  def all
    @team
  end
  def seniors
    @team.select{ |dev| dev.TYPE == :seniors}
  end
  def developers
    @team.select{ |dev| dev.TYPE == :developers}
  end
  def juniors
    @team.select{ |dev| dev.TYPE == :juniors}
  end

  def priority (*prior)
    @prior = *prior
    # @prior.map.with_index{ |x,i| puts "#{x} -- #{i}"}
    # @team.map { |dev| puts "#{dev.name} == #{dev.MAX_TASKS}"}
    @team.map { |dev| @prior.map.with_index{ |priority,i| dev.priority = i if dev.TYPE == priority }}
  end

  def on_task
  end 

  def add_task (task_name)
    @team.sort_by!{|dev| [dev.task_array.count, dev.priority]}.first.add_task(task_name)  
  end 

  def report
    @team.sort_by{|dev| [dev.task_array.count, dev.priority]}.map{ |dev| puts "#{dev.name} (#{dev.STYPE}): #{dev.task_array.map{|x| x}.join(", ")}"} 
  end
end

t = Team.new()
t.have_seniors 'SDev1', 'SDev2'
t.have_developers 'Dev1', 'Dev2'
t.have_juniors 'JDev1', 'JDev2', 'JDev3'
t.priority  :juniors, :developers, :seniors
# t.seniors.map{ |dev| puts dev.class}
#p t.all.map{ |dev| puts dev.name}
p t.prior
puts "*****Report*******"
t.report
#t.team[1].add_task('ff')
t.add_task ('d1')
#t.report
t.add_task ('d2')
# t.report
t.add_task ('d3')
# t.report
t.add_task ('d4')
# t.report
t.add_task ('d5')
# t.report
t.add_task ('d6')
# t.report
t.add_task ('d7')
# t.report
t.add_task ('d8')
t.report
puts t.seniors
puts t.developers
puts t.juniors
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



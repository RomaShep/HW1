class Developer
  attr_reader :name, :task_array, :TYPE, :STYPE
  attr_accessor :priority 
  
  MAX_TASKS = 10
  GROUP = :developers
  TYPE = :developer

  def initialize(name)
    @name = name
    @task_array = []
    @priority = 999
  end

  def MAX_TASKS
    self.class::MAX_TASKS
  end

  def GROUP
    self.class::GROUP
  end

  def TYPE
    self.class::TYPE
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
    @task_array.count < self.class::MAX_TASKS
  end

  def can_work?
    !@task_array.empty?
  end 
end

class JuniorDeveloper < Developer
  MAX_TASKS = 5
  GROUP = :juniors
  TYPE = :junior
  MAX_LENGTH = 20

  def add_task (task_name)
    raise "Слишком сложно!" if task_name.length >= MAX_LENGTH
    super
  end

  def work!
    check_work
    puts %Q{#{@name}: пытаюсь делать задачу '#{@task_array.shift}'. Осталось задач: #{@task_array.count}}
  end
end

class SeniorDeveloper < Developer
  MAX_TASKS = 15
  GROUP = :seniors
  TYPE = :senior

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
  #attr_accessor :seniors, :developers, :juniors
  attr_accessor :prior, :team

  def initialize
    @team = []  
    @prior = []                    
  end                               
    
  def have_seniors(*dev_name)     dev_name.map{ |name| @team << SeniorDeveloper.new(name)} end
  def have_developers(*dev_name)  dev_name.map{ |name| @team << Developer.new(name)} end
  def have_juniors(*dev_name)     dev_name.map{ |name| @team << JuniorDeveloper.new(name)} end
  
  def seniors()     @team.select{ |dev| dev.TYPE == :senior}  end
  def developers () @team.select{ |dev| dev.TYPE == :developer} end
  def juniors ()    @team.select{ |dev| dev.TYPE == :junior} end

  def all() @team end

  def priority (*prior)
    @prior = *prior
    # @prior.map.with_index{ |x,i| puts "#{x} -- #{i}"}
    # @team.map { |dev| puts "#{dev.name} == #{dev.MAX_TASKS}"}
    @team.map { |dev| @prior.map.with_index{ |priority,i| dev.priority = i if dev.GROUP == priority }}
  end

  def on_task(developer, &block)
    on_task_developer[developer] = block
  end

  def on_task_developer
    @on_task_developer ||= {}
  end

  # def on_task(options={}, proc)
  #   proc.call
  # end 
  
  # def add_task (task)
  #   sort_team.first.add_task(task)
  # end 
  def add_task (task_list, options={})
    # if !options[:complexity].nil? and !options[:to].nil?
    #   task_list.map do |task| 
    #     a=sort_team.select{|dev| dev.TYPE == options[:complexity] && dev.name == options[:to]}
    #     unless a.empty?
    #       a.first.add_task(task)
    #     else
    #       raise "Нет разработчика: #{options[:to]} уровня - #{options[:complexity]}"
    #     end
    #   end 
    # elsif !options[:complexity].nil?
    #   task_list.map do |task| 
    #     a=sort_team.select{|dev| dev.TYPE == options[:complexity]}
    #     unless a.empty?
    #       a.first.add_task(task)
    #     else
    #       raise "Нет разработчика уровня - #{options[:complexity]}"
    #     end
    #   end
    # elsif !options[:to].nil?
    #   task_list.map do |task| 
    #     a=sort_team.select{|dev| dev.name == options[:to]}
    #     unless a.empty?
    #       a.first.add_task(task)
    #     else
    #       raise "Нет разработчика: #{options[:to]}"
    #     end
    #   end
    # else      
      task_list.map{|task| sort_team.first.add_task(task)}
    #end
  end 

  def report
    sort_team.map{|dev| puts "#{dev.name} (#{dev.TYPE}): #{dev.task_array.map{|x| x}.join(", ")} "} #{dev.priority} -- #{!dev.can_add_task?}"} 
  end
  def sort_team
    @team.sort_by{|dev| [dev.task_array.count, dev.priority]  }.sort{|a,b|  (a.can_add_task? == b.can_add_task?) ? 0 : (a.can_add_task? ? -1 : 1)}
    #@team.sort_by{|dev| [dev.task_array.count, dev.priority]}.sort{|a,b|  (a.can_add_task? == b.can_add_task?) ? 0 : (a.can_add_task? ? -1 : 1)}
  end
end

t = Team.new()
t.have_seniors 'SDev1', 'SDev2', 'Ivan'
t.have_developers 'Dev1', 'Dev2', 'Ivan'
t.have_juniors 'JDev1', 'JDev2', 'JDev3'
t.priority  :developers, :juniors #,:seniors 
# t.seniors.map{ |dev| puts dev.class}
#p t.all.map{ |dev| puts dev[:dev].name}
# puts t.seniors
# puts t.prior
puts "*****Report*******"
#t.report
t.add_task ['T1','t2'],  to: 'Ivan'
# 60.times{ |i| t.add_task "T#{i}"}
t.report
# p t.juniors

# jun = JuniorDeveloper.new('Sid')
# p jun.MAX_TASKS
# puts t.seniors
# puts t.developers
# puts t.juniors
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



class Developer
  attr_reader :name, :task_array
  attr_accessor :GROUP, :TYPE
  
  MAX_TASKS = 10
  GROUP = :developers
  TYPE = :developer

  def initialize(name)
    @name = name
    @task_array = []
  end

  def max_tasks
    self.class::MAX_TASKS
  end

  def group
    self.class::GROUP
  end

  def type
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
    @task_array.count < max_tasks
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
  attr_accessor :Priority, :team

  def initialize(&block)
    @team = []  
    @Priority = [:juniors, :developers ,:seniors] 
    if block 
      instance_eval &block 
    end
  end                               
    
  def have_seniors(*dev_name)     dev_name.map{ |name| @team << SeniorDeveloper.new(name)} end
  def have_developers(*dev_name)  dev_name.map{ |name| @team << Developer.new(name)} end
  def have_juniors(*dev_name)     dev_name.map{ |name| @team << JuniorDeveloper.new(name)} end
  
  def seniors()     @team.select{ |dev| dev.type == :senior}  end
  def developers () @team.select{ |dev| dev.type == :developer} end
  def juniors ()    @team.select{ |dev| dev.type == :junior} end

  def all() @team end

  def priority (*priority_list)
    @Priority = *priority_list
  end

  def on_task(method, &block)
    on_task_blocks[method] = block
  end
  def on_task_blocks
    @on_task_blocks ||= {} 
  end


  def add_task (task, options={})

    if !options[:complexity].nil? and !options[:to].nil?
      a=sort_team.select{|dev| dev.type == options[:complexity] && dev.name == options[:to]}.first
      raise "Нет разработчика: #{options[:to]} уровня - #{options[:complexity]}" if a.nil?
    elsif !options[:complexity].nil?
      a=sort_team.select{|dev| dev.type == options[:complexity]}.first
      raise "Нет разработчика уровня - #{options[:complexity]}" if a.nil?
    elsif !options[:to].nil?
      a=sort_team.select{|dev| dev.name == options[:to]}.first
      raise "Нет разработчика: #{options[:to]}" if a.nil?
    else      
      a=sort_team.first
      raise "Нет разработчиков!!!}" if a.nil?
    end

    a.add_task(task)
    after = on_task_blocks[a.type]
    if after
      after.call(a,task)
    end
  end 

  def report
    sort_team.map{|dev| puts "#{dev.name} (#{dev.type}): #{dev.task_array.map{|x| x}.join(", ")} "}
    #sort_team.map{|dev| puts "#{dev.name} (#{dev.type}): #{dev.task_array.count} -- priority -- #{@prior.index(dev.groupe)} -- Can add task: #{dev.can_add_task?} -- #{dev.MAX_TASKS } "} 
    
  end
  def sort_team
    @team.select{|dev| !@Priority.index(dev.group).nil? }.sort_by{|dev|  [(dev.can_add_task? ? -1 : 1),dev.task_array.count, @Priority.index(dev.group)]}
  end
end

t = Team.new do
  have_seniors 'SDev1', 'SDev2'
  have_developers 'Dev1', 'Dev2'
  have_juniors 'JDev1', 'JDev2', 'JDev3'
  priority  :juniors, :developers ,:seniors 

  on_task :junior do |dev,task|
    puts "Отдали задачу #{task} разработчику #{dev.name}, следите за ним!"
  end

  on_task :senior do |dev, task|
    puts "#{dev.name} сделает #{task}, но просит больше с такими глупостями не приставать"
  end
end


#p t.seniors
#puts "*****Report*******"
#t.report
#t.add_task ['T1','t2'],  to: 'Ivan'
14.times{ |i| t.add_task "T#{i}" }#, complexity: :senior, to: 'SDev1'}
t.report
#t.report
# p t.juniors





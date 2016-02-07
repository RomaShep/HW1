x,y,x1,y1 = ARGV

if x==x1 and y==y1 
  puts 'Точка найдена'
elsif x==x1 and y!=y1
  puts 'х координата верна, y нет'
elsif x!=x1 and y==y1
  puts 'y координата верна, x нет'
else
  puts 'Близко, но нет '
end
  
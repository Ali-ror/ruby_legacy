puts "----------> Starting run"
p Time.now

bls = BusinessListing.resellers.all
bls.each do |bl|
  begin

    putc '.'
    bl.address.save
    sleep 2

  rescue => e
    puts e.inspect
    puts e.backtrace
    p Time.now
  end
end

puts ""
puts "----------> Ending run"
p Time.now

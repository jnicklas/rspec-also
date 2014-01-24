require "pp"

class Also
  attr_reader :id
  attr_reader :block
  attr_reader :queue

  def initialize(id, &block)
    @id = id
    @block = block
    @blocks = []
  end

  def enqueue(also)
    @blocks.push(also) unless @blocks.find { |a| a.id == also.id }
  end

  def run!
    @run = true
    @block.call
  end

  def run?
    @run
  end

  def queue
    @blocks.reject(&:finished?)
  end

  def current?(id)
    @blocks.last and queue.last.id == id
  end

  def finished?
    @run and queue.empty?
  end

  def inspect
    "<Also #{@id} #{@run} #{finished?}>"
  end
end

describe "foo" do
  def also(id, &block)
    if @current_also.current?(id)
      last = @current_also.queue.last
      run_also(last)
      throw :also, true
    else
      @current_also.enqueue(Also.new(id, &block))
    end
  end

  def run_also(also)
    original = @current_also
    @current_also = also

    also.run!

    if last = also.queue.last
      run_also(last)
      throw :also, true
    end
  ensure
    @current_also = original
  end

  around do |runner|
    top_level = Also.new("top-level") do
      runner.run
    end

    until top_level.finished?
      catch :also do
        run_also(top_level)
      end
    end
  end

  before do
    puts "--> BEFORE"
  end

  after do
    puts "--> AFTER"
  end

  it "bar" do
    puts "1"

    also("A") do
      puts "1.1"

      also("A.A") do
        puts "1.1.1"
      end

      puts "1.1-c"

      also("A.B") do
        puts "1.1.2"
      end
    end

    puts "X"

    also("B") do
      puts "1.2"

      also("B.A") do
        puts "1.2.1"
      end

      puts "1.2-c"

      also("B.B") do
        puts "1.2.2"
      end
    end
  end
end

__END__

1
1.1
1.1.1
1
1.1
1.1-c
1.1.2
1
1.2

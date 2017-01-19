# A simple event registering/triggering module to mix into classes.
# Events are stored in the `@events` ivar.
module Eventable

  # Risc a handler for the given event name.
  # The event name is the method name called on the handler object
  #
  #   obj.on(:foo , some_object_that_implements foo( whateverargs)
  #
  # @param [String, Symbol] name event name
  # @param [Object] object handling the event, ie implement the function name
  # @return handler
  def register_event(name, handler)
    event_table[name] << handler
    handler
  end

  def unregister_event(name, handler)
    event_table[name].delete handler
  end

  def event_table
    return @event_table if @event_table
    @event_table = Hash.new { |hash, key| hash[key] = [] }
  end

  # Trigger the given event name and passes all args to each handler
  # for this event.
  #
  #   obj.trigger(:foo)
  #   obj.trigger(:foo, 1, 2, 3)
  #
  # @param [String, Symbol] name event name to trigger
  def trigger(name, *args)
    event_table[name].each { |handler| handler.send( name.to_sym , *args) }
  end
end

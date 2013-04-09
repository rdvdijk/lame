module SetterGetter
  def has_getter?(lame, flag)
    lame.respond_to?(:"lame_get_#{flag}")
  end

  def has_setter?(lame, flag)
    lame.respond_to?(:"lame_set_#{flag}")
  end

  def set_value(lame, flag)
    lame.send(:"lame_set_#{flag}", @flags_pointer, @value) == return_value
  end

  def return_value
    defined?(@return) ? @return : 0
  end

  def has_value?(lame, flag)
    if @value && @value.is_a?(Float)
      actual = actual_value(lame, flag)
      (actual - @value).abs < 0.0001
    elsif @value
      actual_value(lame, flag) == @value
    else
      true
    end
  end

  def actual_value(lame, flag)
    lame.send(:"lame_get_#{flag}", @flags_pointer)
  end
end

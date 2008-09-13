require File.expand_path(File.dirname(__FILE__) + "/../test_helper")


# fixture:
class MyTestCell < Apotomo::StatefulWidget
  def a_state
    "a_state"
  end
end

class TestWidgetTree < Apotomo::WidgetTree  
  def draw(root)
    root << tab_panel = Apotomo::TabPanelWidget.new(@controller, 'my_tab_panel', :switch)
      tab_panel << Apotomo::TabWidget.new(@controller, 'tab_one', :widget_content, 
        :title => "Tab One")
  end
end


class SwitchTestWidgetTree < Apotomo::WidgetTree  
  def draw(root)
    root << first = Apotomo::ChildSwitchWidget.new(@controller, 'first_switch', :switch)
      first << second = Apotomo::ChildSwitchWidget.new(@controller, 'second_switch', :switch)
       second << cell(:my_test, :a_state, 'first_child')
       second << cell(:my_test, :a_state, 'second_child')
  end
end



class TabPanelTest < Test::Unit::TestCase
  include Apotomo::UnitTestCase
  
  def test_tab_panel
    p = tab_panel('my_tab_panel')
      p << tab("First")
      p << tab("Second")
      p << tab("Third")
    
    c = p.render_content
    
    assert_selekt c, "div.TabPanel>#tab_one"
  end
  
  def test_tab_panel_rendering
    return  ### TODO: rewrite Tabnav.
    
    tab_panel = tab_panel('my_tab_panel')
      tab_panel << Apotomo::TabWidget.new(@controller, 'tab_one', :widget_content, 
        :title => "Tab One")
    
    c = tab_panel.render_content
    assert_selekt c, "div.TabPanel>#tab_one"
  end
  
  
  def test_tab_widget_api
    t = Apotomo::TabWidget.new(@controller, 'tab_id', :widget_content, :title => "The Tab")
    
    assert_equal t.title, "The Tab"
  end
  
  
  def test_switch_addressing
    @controller.session = {}
    tree = SwitchTestWidgetTree.new(@controller)
    r = tree.draw_tree.root
    
    child1  = r.find_by_id('first_child')
    child2  = r.find_by_id('second_child')
    
    assert_equal child1.address['first_switch_child'], 'second_switch'
    assert_equal child1.address['second_switch_child'], 'first_child'
    assert_equal child2.address['first_switch_child'], 'second_switch'
    assert_equal child2.address['second_switch_child'], 'second_child'
  end
    
end

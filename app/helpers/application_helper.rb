module ApplicationHelper
  
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end
  
  def display_base_errors resource
    
    
   if resource.errors.any?
     
    html = <<-HTML
    <div id="error_explanation">
      <div class="alert alert-error">
      The form contains #{pluralize(resource.errors.count, "error")}.
      </div> 
    
    HTML
    
    resource.errors.full_messages.each do |messages| 
     
     html = html + <<-HTML
     <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
        #{messages}
      </div>  
      HTML
      
     end 
     
    html = html + "</div>" 
    
    html.html_safe
  
      
   end
  
  end

end
module ApplicationHelper

  def round (param)
    number_with_precision(param, precision: 1)
  end

  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]), class:"btn btn-primary")
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class:"btn btn-danger")
      raw("#{edit} #{del}")
    end
  end

end

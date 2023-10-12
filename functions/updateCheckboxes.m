function updateCheckboxes(event, checkbox_grey, checkbox_yellow, radio_random)
    % If the 'Random' radio button is selected
    if event.NewValue == radio_random
        checkbox_grey.Visible = 'on';
        checkbox_yellow.Visible = 'on';
    else
        checkbox_grey.Visible = 'off';
        checkbox_yellow.Visible = 'off';
    end
end

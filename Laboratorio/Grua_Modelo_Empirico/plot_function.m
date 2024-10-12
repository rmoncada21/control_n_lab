function plot_function(tiempo, y_lsim, line_width, ...
    titulo, fontsize_, titulo_legend)
    
    figure;
    plot(tiempo, y_lsim)
    h = findobj(gca, 'Type', 'line');

    % Grosor de la línea
    set(h, 'LineWidth', line_width);

    % Ajustar el tamaño de las etiquetas
    title(titulo, 'FontSize', fontsize_);
    xlabel('Tiempo', 'FontSize', fontsize_);
    ylabel('Amplitud', 'FontSize', fontsize_);
    set(gca, 'FontSize', fontsize_);
    legend(titulo_legend);

end
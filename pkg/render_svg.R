# A simple convienent function for rendering non cairo images with rsvg.

render_svg <- function(symbol_path, symbold_file_name) {
  require(rsvg)

  if (!dir.exists(base::paste(symbol_path, 'rendered/', sep = ''))) {
    base::dir.create(base::paste(symbol_path, 'rendered/', sep = ''))
  }

  target_file_path <- base::paste(symbol_path, 'rendered/', 'rendered_', symbold_file_name, sep = '')

  rsvg_svg(svg    = base::paste(symbol_path, symbold_file_name, sep = ''), 
           file   = target_file_path, 
           width  = 1000, 
           height = 1000)
  
  return(target_file_path)
}

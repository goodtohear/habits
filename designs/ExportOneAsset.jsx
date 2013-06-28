var document = app.activeDocument;
var artboard = document.artboards[document.artboards.getActiveArtboardIndex()];
exportArtboard(artboard, 100, "");
exportArtboard(artboard, 200, "@2x");

function exportArtboard(artboard, scale, suffix) {
  var options = new ExportOptionsPNG24();
  options.antiAliasing = true;
  options.transparency = true; 
  options.artBoardClipping = true;
  options.horizontalScale = scale;
  options.verticalScale = scale;
  
  var filename = artboard.name + suffix + ".png";
  // FIXME: make a dialog box.
  var base_path = "/Users/michaelforrest/workspaces/motion/habits/resources";
  var destination_path = base_path + "/" + filename;
  var outputFile = new File(destination_path);
  document.exportFile(outputFile, ExportType.PNG24, options);
  
  
};

import 'dart:html';
import 'package:render_stats/render_stats.dart';

RenderStats renderStats;

void main() {
  // Create an instance of the RenderStats control
  renderStats = new RenderStats();
  
  // Append the RenderStats dom element to the page body
  document.body.append(renderStats.domElement);
  
  // Begin the render loop
  window.requestAnimationFrame(update); 
}

void update(double time) {
  window.requestAnimationFrame(update);
  
  // Wrap your rendering with begin() and end() to produce the performance graph
  renderStats.begin();
  // TODO: Canvas or WebGL Rendering happens here!
  renderStats.end();
}


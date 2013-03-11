/*
 * Copyright (c) 2013 Brandon Jones
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *    1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 *
 *    2. Altered source versions must be plainly marked as such, and must not
 *    be misrepresented as being the original software.
 *
 *    3. This notice may not be removed or altered from any source
 *    distribution.
 */

/*
 * Dart port of Stats.js by mrdoob 
 * https://github.com/mrdoob/stats.js
 */

library render_stats;

import "dart:core";
import "dart:html";
import "dart:math" as Math;

class RenderStats {
// Public:
  static const int REVISION = 1;
  
  static const int FPS_MODE = 0;
  static const int MS_MODE = 1;
  
  RenderStats() {
    _createElements();
    
    _watch = new Stopwatch()..start();
    _startTime = _prevTime = _watch.elapsedMilliseconds;
  }
  
  void set mode(int value) {
    _mode = value;

    switch (_mode) {
      case FPS_MODE:
        _fpsDiv.style.display = 'block';
        _msDiv.style.display = 'none';
        break;
      case MS_MODE:
        _fpsDiv.style.display = 'none';
        _msDiv.style.display = 'block';
        break;
    }
  }
  
  int get mode => _mode;
  
  Element get domElement => _container;

// Private:
  const int _graphSegments = 74;
  
  Stopwatch _watch;
  
  int _startTime;
  int _prevTime;
  
  int _ms = 0;
  num _msMin = double.INFINITY, _msMax = 0;
  
  int _fps = 0;
  num _fpsMin = double.INFINITY, _fpsMax = 0;
  
  int _frames = 0;
  int _mode = 0;
  
  Element _container;
  Element _fpsDiv, _fpsText, _fpsGraph;
  Element _msDiv, _msText, _msGraph;
  
  void _createElements() {
    _container = new Element.tag("div");
    _container.id = "stats";
    _container.onMouseDown.listen((event) => mode = ++_mode % 2);
    _container.style.cssText = "width:80px;opacity:0.9;cursor:pointer";
    
    _fpsDiv = new Element.tag("div");
    _fpsDiv.id = "fps";
    _fpsDiv.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#002";
    _container.append( _fpsDiv );
    
    _fpsText = new Element.tag("div");
    _fpsText.id = "fpsText";
    _fpsText.style.cssText = "color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px";
    _fpsText.text = 'FPS';
    _fpsDiv.append( _fpsText );
    
    _fpsGraph = new Element.tag("div");
    _fpsGraph.id = "fpsGraph";
    _fpsGraph.style.cssText = "position:relative;width:74px;height:30px;background-color:#0ff";
    _fpsDiv.append( _fpsGraph );
    
    while(_fpsGraph.children.length < _graphSegments) {
      Element bar = new Element.tag("div");
      bar.style.cssText = "width:1px;height:30px;float:left;background-color:#113";
      _fpsGraph.append(bar);
    }
    
    _msDiv = new Element.tag("div");
    _msDiv.id = "ms";
    _msDiv.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#020;display:none";
    _container.append( _msDiv );
    
    _msText = new Element.tag("div");
    _msText.id = "msText";
    _msText.style.cssText = "color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px";
    _msText.text = "MS";
    _msDiv.append( _msText );
    
    _msGraph = new Element.tag("div");
    _msGraph.id = "msGraph";
    _msGraph.style.cssText = "position:relative;width:74px;height:30px;background-color:#0f0";
    _msDiv.append( _msGraph );
    
    while(_msGraph.children.length < _graphSegments) {
      Element bar = new Element.tag("div");
      bar.style.cssText = "width:1px;height:30px;float:left;background-color:#131";
      _msGraph.append(bar);
    }
  }
  
  void _updateGraph(Element graph, num value) {
    Element bar = graph.children[0];
    graph.append(bar);
    bar.style.height = "${value}px";
  }
  
  void begin() {
    _startTime = _watch.elapsedMilliseconds;
  }
  
  void update() {
    _startTime = end();
  }
  
  int end() {
    int time = _watch.elapsedMilliseconds;
    
    _ms = time - _startTime;
    _msMin = Math.min(_msMin, _ms);
    _msMax = Math.max(_msMax, _ms);

    _msText.text = "${_ms} MS (${_msMin}-${_msMax})";
    _updateGraph(_msGraph, Math.min(30, 30 - ( _ms / 200 ) * 30));

    _frames++;

    if (time > _prevTime + 1000) {
      _fps = ((_frames * 1000) / (time - _prevTime)).round().toInt();
      _fpsMin = Math.min(_fpsMin, _fps);
      _fpsMax = Math.max(_fpsMax, _fps);

      _fpsText.text = "${_fps} FPS (${_fpsMin}-${_fpsMax})";
      _updateGraph(_fpsGraph, Math.min(30, 30 - (_fps / 100) * 30));

      _prevTime = time;
      _frames = 0;
    }
    
    return time;
  }
}

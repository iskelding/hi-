Ship ship;
boolean ahitast = true; //do asteroids kill UFO?
boolean alaserast = true; //do UFO lasers break asteroids?
boolean[] keysPressed = new boolean[3];
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<gun> guns = new ArrayList<gun>();
ArrayList<Agun> agun = new ArrayList<Agun>();
ArrayList<Alienship> aships = new ArrayList<Alienship>();
ArrayList<boom> dust = new ArrayList<boom>();
PVector temppos;
int state = 0;
PFont font;
float score = 0;
float numast = 4;
float numship = 1;
final int numberAsteroids = 4;
final int numships = 1;
float add = 0.5;
float shipadd = 0.2;
float time = 1;
float cshoot = 0.005;
final float cshoot1 = 0.005;

void setup() {
  fullScreen();
  font = createFont("Century Gothic", 100);
  ship = new Ship();
  for (int i = 0; i < numast; i++) {
    asteroids.add(new Asteroid(temppos, random(80, 100), 1));
  }
  scale(0.5);
}

void keyPressed() {
  if (keyCode == RIGHT) {
    ship.setRotation(0.1);
  } else if (keyCode == LEFT) {
    ship.setRotation(-0.1);
  } else if ((keyCode == UP) && (state == 1)) {
    ship.isacc(true);
  } else if ((key == ' ') && (state == 1)) {
    if (frameCount % 1 == 0) {
      guns.add(new gun(ship.pos, ship.heading));
    }
  } else if (((key == 'p') || (key == 'P')) && (state == 1)) {
    state = 3;
  } else if (((key == 'p') || (key == 'P')) && (state == 3)) {
    state = 1;
  }
}

void keyReleased() {
  if (keyCode == RIGHT) {
    ship.setRotation(0);
  } else if (keyCode == LEFT)  {
    ship.setRotation(0);
  } else if (keyCode == UP) {
    ship.isacc(false);
  } else if (key == ' ') {
  }
}
void draw() {
  background(0);
  if (state == 1) {
    for (int i = 0; i < asteroids.size(); i++) {
      stroke(255);
      noFill();
      Asteroid asteroid = asteroids.get(i);
      asteroid.render();
      asteroid.update();
      asteroid.wrap();
      if ((ship.hits(asteroid.pos, asteroid.r)) && (ship.flashing == false)) {
        state = 2;
      }
      for (int j = aships.size()-1; j >= 0; j--) {
        Alienship a = aships.get(j);
        if (ahitast) {
          if (a.hits(asteroid.pos, asteroid.r)) {
            aships.remove(j);
            for(int m = 0; m < 4; m++){
              boom p = new boom(a.pos);
              p.vel.setMag(random(3, 5));
              p.vel.mult(random(0.9, 1.1));
              p.r = random(5, 12);
              dust.add(p);
            }
          }
        }
      }
    }
    if(dust.size() != 0){
      for(int i = dust.size()-1; i >= 0; i--){
        boom p = dust.get(i);
        p.render();
        p.update();
        if(p.dead){
          dust.remove(i);
        }
      }
    }
    
    stroke(255);
    
    if ((frameCount > 0) && (aships.size() < numship)) {
      Alienship alienship = new Alienship();
      if (random(1) < 0.005) aships.add(alienship);
    }

    for (int i = guns.size()-1; i >= 0; i--) {
      gun laser = guns.get(i);
      laser.render();
      laser.update();
      if (laser.offscreen()) {
        guns.remove(i);
      } else {
        for (int n = aships.size()-1; n >= 0; n--) {
          Alienship a = aships.get(n);
          if (laser.hits(a.pos, a.r)) {
            score += 1000;
            aships.remove(n);
            for(int m = 0; m < 4; m++){
              boom p = new boom(a.pos);
              p.vel.setMag(random(3, 5));
              p.vel.mult(random(0.9, 1.1));
              p.r = random(5, 12);
              dust.add(p);
            }
          }
        }
        for (int j = asteroids.size()-1; j >= 0; j--) {
          Asteroid asteroid = asteroids.get(j);
          if (laser.hits(asteroid.pos, asteroid.r)) {
            if (asteroid.r > 30) {
              ArrayList<Asteroid> newAsteroids = asteroid.breakup();
              asteroids.addAll(newAsteroids);
            } else {
            }
            score += map(asteroid.r, 100, 0, 0, 200);
            asteroids.remove(j);
            PVector dustpos = new PVector(asteroid.pos.x, asteroid.pos.y);
            for(int m = 0; m < map(asteroid.iteration, 0, 5, 5, 3); m++){
              boom p = new boom(dustpos);
              p.vel.setMag(map(asteroid.iteration, 0, 5, 3, 6));
              p.vel.mult(random(0.9, 1.1));
              p.r = random(5, 12);
              dust.add(p);
            }
            if (asteroids.size() < numast) {
              int temprand = int(random(0, 2));
              int temprand1 = int(random(0, 2));
              if ((temprand == 1) && (temprand1 == 1)) {
                temppos = new PVector(width, random(0, height));
              } else if ((temprand == 0) && (temprand1 == 1)) {
                temppos = new PVector(random(0, width), height);
              } else if ((temprand == 1) && (temprand1 == 0)) {
                temppos = new PVector(random(0, width), 0);
              } else {
                temppos = new PVector(0, random(0, height));
              }
              asteroids.add(new Asteroid(temppos, random(80, 100), 1));
              add *= random(1, 1.05);
              numast += random(0, add);
            }
            guns.remove(i);
            break;
          }
        }
      }
    }
  if(agun.size() > 0){
      for (int i = agun.size()-1; i >= 0; i--) {
        Agun alaser = agun.get(i);
        alaser.render();
        alaser.update();
        if (alaserast) {
          for (int j = asteroids.size()-1; j >= 0; j--) {
            Asteroid asteroid = asteroids.get(j);
            if (alaser.hitsa(asteroid.pos, asteroid.r)) {
              if (asteroid.r > 30) {
                ArrayList<Asteroid> newAsteroids = asteroid.breakup();
                asteroids.addAll(newAsteroids);
              }
              PVector dustpos = new PVector(asteroid.pos.x, asteroid.pos.y);
              for(int m = 0; m < map(asteroid.iteration, 0, 5, 5, 3); m++){
                boom p = new boom(dustpos);
                p.vel.setMag(map(asteroid.iteration, 0, 5, 3, 6));
                p.vel.mult(random(0.9, 1.1));
                p.r = random(5, 10);
                dust.add(p);
              }
              asteroids.remove(j);
              agun.remove(i);
            }
          }
        }
        if (alaser.offscreen()) {
          agun.remove(i);
        } else {
          if (alaser.hits(ship)) {
            state = 2;
          }
        }
      }
    }

    for (int i = aships.size()-1; i >= 0; i--) {
      strokeWeight(5);
      Alienship a = aships.get(i);
      a.render();
      a.update();
      a.wrap();
      for (int j = 0; j < aships.size(); j++) {
        Alienship aship = aships.get(i);
        if (random(1) < cshoot) {
          Agun alaser = new Agun(aship.pos, ship.pos);
          agun.add(alaser);
          if(random(1) < 0.1) cshoot *= random(1, 1.1);
        }
      }
    }

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Score: " + floor(score/10)*10, width-200, 100);
    stroke(255);
    strokeWeight(5);
    ship.update();
    ship.render();
    ship.turn();
    ship.wrap();
  } else if (state == 2) {
    strokeWeight(5);
    textFont(font); 
    ship.flashing = false;
    ship.isAccel = false;
    stroke(255, 100);
    ship.render();
    stroke(255, 100);
    for (int i = 0; i < asteroids.size(); i++) {
      Asteroid asteroid = asteroids.get(i);
      asteroid.render();
    }
    for (int i = 0; i < agun.size(); i++) {
      Agun alaser = agun.get(i);
      alaser.render();
    }
    for (int i = 0; i < aships.size(); i++) {
      Alienship a = aships.get(i);
      a.render();
    }
    
    for(boom p : dust){
      p.render();
    }
    //stroke(255);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(100);
    text("GAME OVER", width/2, height/2-100);
    text("Final score: " + floor(score)*10, width/2, height/2+100);
    if (mousePressed) {
      add = 0.5;
      state = 1;
      score = 0;
      ship = new Ship();
      asteroids.clear();
      guns.clear();
      aships.clear();
      agun.clear();
      dust.clear();
      numast = numberAsteroids;
      numship = numships;
      cshoot = cshoot1;
      for (int i = 0; i < numast; i++) {
        temppos = new PVector(random(0, width), random(0, height));
        asteroids.add(new Asteroid(temppos, random(80, 100), 1));
      }
    }
  } else if (state == 0) {
    textFont(font);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(100);
    text("Click to start", width/2, height/2);
    if ((mousePressed) ||((keyPressed) && (key == ' '))) {
      state = 1;
    }
  } else if (state == 3) {
    textFont(font);
    textAlign(CENTER, CENTER);
    stroke(255, 100);
    textSize(100);
    strokeWeight(5);
    for (int i = 0; i < asteroids.size(); i++) {
      Asteroid asteroid = asteroids.get(i);
      asteroid.render();
    }
    for (int i = 0; i < agun.size(); i++) {
      Agun alaser = agun.get(i);
      alaser.render();
    }
    for (int i = 0; i < aships.size(); i++) {
      Alienship a = aships.get(i);
      a.render();
    }
    for (int i = 0; i < guns.size(); i++) {
      gun l = guns.get(i);
      l.render();
    }
    
    for(boom p : dust){
      p.render();
    }
    
    stroke(255);
    
    ship.render();
    fill(255);
    text("PAUSED", width/2, height/2);
    noFill();
  }
}

class Variables {
  double temperature;

  Variables({
    this.temperature = 1.0
    });

   void setTemperature(double tempe){
    this.temperature = tempe;
  }

  double getTemperature(){
    return this.temperature;
  }
}
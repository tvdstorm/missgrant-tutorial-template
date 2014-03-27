public class missgrant {
  public static void main(String args[]) throws java.io.IOException { 
     new missgrant().run(new java.util.Scanner(System.in), 
                    new java.io.PrintWriter(System.out));
  }
  
  private static final int state$idle = 0;
  
  private static final int state$active = 1;
  
  private static final int state$waitingForLight = 2;
  
  private static final int state$waitingForDrawer = 3;
  
  private static final int state$unlockedPanel = 4;
  
  void run(java.util.Scanner input, java.io.Writer output) throws java.io.IOException {
    int state = state$idle;
    while (true) {
      String token = input.nextLine();
      switch (state) {
        
        case state$idle: {
          
             unlockDoor(output);
          
             lockPanel(output);
          
          
          if (doorClosed(token)) {
             state = state$active;
          }
          
          if (doorOpened(token)) {
             state = state$idle;
          }
          
          break;
        }
        
        case state$active: {
          
          
          if (drawerOpened(token)) {
             state = state$waitingForLight;
          }
          
          if (lightOn(token)) {
             state = state$waitingForDrawer;
          }
          
          if (doorOpened(token)) {
             state = state$idle;
          }
          
          break;
        }
        
        case state$waitingForLight: {
          
          
          if (lightOn(token)) {
             state = state$unlockedPanel;
          }
          
          if (doorOpened(token)) {
             state = state$idle;
          }
          
          break;
        }
        
        case state$waitingForDrawer: {
          
          
          if (drawerOpened(token)) {
             state = state$unlockedPanel;
          }
          
          if (doorOpened(token)) {
             state = state$idle;
          }
          
          break;
        }
        
        case state$unlockedPanel: {
          
             unlockPanel(output);
          
             lockDoor(output);
          
          
          if (panelClosed(token)) {
             state = state$idle;
          }
          
          if (doorOpened(token)) {
             state = state$idle;
          }
          
          break;
        }
        
      }
    }
  }
  
  // TODO
  
  // TODO
  
  // TODO
  
  // TODO
  
  // TODO
  
  
  // TODO
  
  // TODO
  
  // TODO
  
  // TODO
  
}
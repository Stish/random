import java.applet.Applet;
import java.applet.AudioClip;
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Arc2D;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import javax.sound.sampled.*;
import sun.audio.*;
import javax.imageio.ImageIO;
import javax.swing.*;
import java.util.Random.*;

public class Arcs extends JApplet implements Runnable, KeyListener {
    // array containing arc closure types.
    private static String types[] = {"Arc2D.CHORD","Arc2D.OPEN","Arc2D.PIE"};
    // indicates that animated arc's mouth is closed.
    private static final int CLOSE = 0;
    // indicates that animated arc's mouth is open.
    private static final int OPEN = 1;
    // indicate direction of animated arc. 
    private static final int FORWARD = 0;
    private static final int BACKWARD = 1;
    private static final int DOWN = 2;
    private static final int UP = 3;
    //Field
    private char field[][] = {
    		{ 2, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 3}, 
    		{ 6, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7}, 
    		{ 6, 1,14,24,16,16,16,13, 1,14,16,16,16,16,16,16,16,16,16,16,13, 1,14,16,16,16,24,13, 1, 7}, 
    		{ 6, 1, 1,15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,15, 1, 1, 7}, 
    		{27,13, 1,15, 1,19,16,13, 1,19,16,16,20, 1,19,16,13, 1,19,16,13, 1,11, 1,11, 1,15, 1,14,29}, 
    		{ 6, 1, 1,15, 1,15, 1, 1, 1,15, 0, 0,15, 1,15, 1, 1, 1,15, 1, 1, 1,15, 1,15, 1,15, 1, 1, 7}, 
    		{ 6, 1,14,25, 1,23,13, 1, 1,23,16,24,18, 1,23,13, 1, 1,17,16,20, 1,23,16,25, 1,23,13, 1, 7}, 
    		{ 6, 1, 1,15, 1,15, 1, 1, 1,15, 1,15, 1, 1,15, 1, 1, 1, 1, 1,15, 1,15, 1,15, 1,15, 1, 1, 7}, 
    		{27,13, 1,12, 1,12, 1, 1, 1,12, 1,12, 1, 1,17,16,13, 1,14,16,18, 1,12, 1,12, 1,12, 1,14,29}, 
    		{ 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7}, 
    		{ 6, 1,19,16,16,16,20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,19,16,16,16,20, 1, 7}, 
    		{ 6, 1,15, 1, 1, 1,15, 1,19,16,24,16,20, 1,19,16,20, 1,19,16,16,20, 1,15, 1, 1, 1,15, 1, 7}, 
    		{ 6, 1,15, 1,11, 1,15, 1,15, 1,15, 1,15, 1,15, 0,15, 1,15, 1, 1,15, 1,15, 1,11, 1,15, 1, 7}, 
    		{ 6, 1,12, 1,15, 1,15, 1,15, 1,15, 1,15, 1,23,16,25, 1,15, 1, 1,15, 1,15, 1,15, 1,12, 1, 7}, 
    		{ 6, 1, 1, 1,15, 1,15, 1,15, 1,12, 1,15, 1,15, 1,15, 1,15, 1, 1,15, 1,15, 1,15, 1, 1, 1, 7}, 
    		{ 6, 1,11, 1,15, 1,15, 1,12, 1, 1, 1,12, 1,12, 1,12, 1,12, 1, 1,12, 1,15, 1,15, 1,11, 1, 7}, 
    		{ 6, 1,15, 1,15, 1,15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,15, 1,15, 1,15, 1, 7}, 
    		{ 6, 1,12, 1,15, 1,17,16,13, 1,14,16,16,16,16,16,16,16,16,16,13, 1,14,18, 1,15, 1,12, 1, 7}, 
    		{ 6, 1, 1, 1,15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,15, 1, 1, 0, 7}, 
    		{ 4, 9, 9, 9,26, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,26, 9, 9, 9, 5}, 
    };
    //pics
    private BufferedImage fld_pics[] = new BufferedImage[34];
    //score
    private char[] score_p1 = new char[3];
    private char[] score_p2 = new char[3];
    
    private Thread thread;
    private BufferedImage bimg;
    private int aw, ah;              // animated arc width & height
    private int x = 1, y = 1;                // position of animated arc
    private int x2 = 28, y2 = 18;                // position of animated arc
    
    private int x_monster1 = 14;
    private int y_monster1 = 9;
    private int x_monster2 = 15;
    private int y_monster2 = 10;
    private int x_monster3 = 14;
    private int y_monster3 = 10;
    private int x_monster4 = 15;
    private int y_monster4 = 9;
        
    private int x_mod_monster1 = -1;
    private int y_mod_monster1 = 0;
    private int x_mod_monster2 = 1;
    private int y_mod_monster2 = 0;
    private int x_mod_monster3 = -1;
    private int y_mod_monster3 = 0;
    private int x_mod_monster4 = 1;
    private int y_mod_monster4 = 0;
    
    private char mov_length_monster1 = 5;
    private char mov_length_monster2 = 5;
    private char mov_length_monster3 = 5;
    private char mov_length_monster4 = 5;
    
    private int respawn_time_p1 = 0;
    private int respawn_time_p2 = 0;
    
    private int cnt_time = 0;
    
    private boolean music_on = true;
    
    private int x_border, y_border;
    private int angleStart = 45;     //  the starting angle of the arc
    private int angleExtent = 270;   //  the extent of the angle of the arc
    private int angleStart2 = 225;     //  the starting angle of the arc
    private int angleExtent2 = 275;   //  the extent of the angle of the arc
    private int mouth = CLOSE;  
    private int mouth2 = CLOSE; 
    private int direction = FORWARD;
    private int direction2 = BACKWARD;
    
    AudioClip eat_sound;
    AudioClip die_sound;
    AudioClip theme_song;
 
    public void init() {
        setBackground(Color.black);
        String pic_path = "fld/";
        String music_path = "msc/";
        
        score_p1[0] = 48;
        score_p1[1] = 48;
        score_p1[2] = 48;
        score_p2[0] = 48;
        score_p2[1] = 48;
        score_p2[2] = 48;
        
        try{
            theme_song = Applet.newAudioClip(new URL("file:" + music_path + "theme_03.wav"));
            eat_sound = Applet.newAudioClip(new URL("file:" + music_path + "eat_01.wav"));
            die_sound = Applet.newAudioClip(new URL("file:" + music_path + "die_01.wav"));
            theme_song.loop();
          }
        catch (IOException e) {
          }
        
        try {
        	fld_pics[0] = ImageIO.read(new File(pic_path + "fld_00.png"));
        	fld_pics[1] = ImageIO.read(new File(pic_path + "fld_01.png"));
        	fld_pics[2] = ImageIO.read(new File(pic_path + "fld_02.png"));
        	fld_pics[3] = ImageIO.read(new File(pic_path + "fld_03.png"));
        	fld_pics[4] = ImageIO.read(new File(pic_path + "fld_04.png"));
        	fld_pics[5] = ImageIO.read(new File(pic_path + "fld_05.png"));
        	fld_pics[6] = ImageIO.read(new File(pic_path + "fld_06.png"));
        	fld_pics[7] = ImageIO.read(new File(pic_path + "fld_07.png"));
        	fld_pics[8] = ImageIO.read(new File(pic_path + "fld_08.png"));
        	fld_pics[9] = ImageIO.read(new File(pic_path + "fld_09.png"));
        	fld_pics[10] = ImageIO.read(new File(pic_path + "fld_10.png"));
        	fld_pics[11] = ImageIO.read(new File(pic_path + "fld_11.png"));
        	fld_pics[12] = ImageIO.read(new File(pic_path + "fld_12.png"));
        	fld_pics[13] = ImageIO.read(new File(pic_path + "fld_13.png"));
        	fld_pics[14] = ImageIO.read(new File(pic_path + "fld_14.png"));
        	fld_pics[15] = ImageIO.read(new File(pic_path + "fld_15.png"));
        	fld_pics[16] = ImageIO.read(new File(pic_path + "fld_16.png"));
        	fld_pics[17] = ImageIO.read(new File(pic_path + "fld_17.png"));
        	fld_pics[18] = ImageIO.read(new File(pic_path + "fld_18.png"));
        	fld_pics[19] = ImageIO.read(new File(pic_path + "fld_19.png"));
        	fld_pics[20] = ImageIO.read(new File(pic_path + "fld_20.png"));
        	fld_pics[21] = ImageIO.read(new File(pic_path + "fld_21.png"));
        	fld_pics[22] = ImageIO.read(new File(pic_path + "fld_22.png"));
        	fld_pics[23] = ImageIO.read(new File(pic_path + "fld_23.png"));
        	fld_pics[24] = ImageIO.read(new File(pic_path + "fld_24.png"));
        	fld_pics[25] = ImageIO.read(new File(pic_path + "fld_25.png"));
        	fld_pics[26] = ImageIO.read(new File(pic_path + "fld_26.png"));
        	fld_pics[27] = ImageIO.read(new File(pic_path + "fld_27.png"));
        	fld_pics[28] = ImageIO.read(new File(pic_path + "fld_28.png"));
        	fld_pics[29] = ImageIO.read(new File(pic_path + "fld_29.png"));
        	fld_pics[30] = ImageIO.read(new File(pic_path + "monster1.png"));
        	fld_pics[31] = ImageIO.read(new File(pic_path + "monster2.png"));
        	fld_pics[32] = ImageIO.read(new File(pic_path + "monster3.png"));
        	fld_pics[33] = ImageIO.read(new File(pic_path + "monster4.png"));
        } catch (IOException e) {
        }
    }
    // Resets the position and size of the animated arc
    public void reset(int w, int h) {
        aw = 30;
        ah = 30;
    }

    public void step(int w, int h) {
        // computes the angle start and extent
        if (mouth == CLOSE) {
            angleStart -= 1;
            angleExtent += 2;
        }
        if (mouth == OPEN) {
            angleStart += 1;
            angleExtent -= 2;
        }
        if (mouth2 == CLOSE) {
            angleStart2 -= 1;
            angleExtent2 += 2;
        }
        if (mouth2 == OPEN) {
            angleStart2 += 1;
            angleExtent2 -= 2;
        }
      //Mouth Player 1
        if (direction == FORWARD)
        {
	        if (angleStart == 0)
	            mouth = OPEN;
	        if (angleStart > 45)
	            mouth = CLOSE;
        }
        if (direction == BACKWARD)
        {
	        if (angleStart == 180)
	            mouth = OPEN;
	        if (angleStart > 225)
	            mouth = CLOSE;
        }
        if (direction == DOWN)
        {
	        if (angleStart == 270)
	            mouth = OPEN;
	        if (angleStart > 315)
	            mouth = CLOSE;
        }
        if (direction == UP)
        {
	        if (angleStart == 90)
	            mouth = OPEN;
	        if (angleStart > 135)
	            mouth = CLOSE;
        }
        //Mouth Player 2
        if (direction2 == FORWARD)
        {
	        if (angleStart2 == 0)
	            mouth2 = OPEN;
	        if (angleStart2 > 45)
	            mouth2 = CLOSE;
        }
        if (direction2 == BACKWARD)
        {
	        if (angleStart2 == 180)
	            mouth2 = OPEN;
	        if (angleStart2 > 225)
	            mouth2 = CLOSE;
        }
        if (direction2 == DOWN)
        {
	        if (angleStart2 == 270)
	            mouth2 = OPEN;
	        if (angleStart2 > 315)
	            mouth2 = CLOSE;
        }
        if (direction2 == UP)
        {
	        if (angleStart2 == 90)
	            mouth2 = OPEN;
	        if (angleStart2 > 135)
	            mouth2 = CLOSE;
        }
    }

    public void drawDemo(int w, int h, Graphics2D g2) 
    {
        g2.setStroke(new BasicStroke(5.0f));

        Arc2D player1 = new Arc2D.Float(Arc2D.PIE);
        player1.setFrame(0, 0, aw, ah);
        player1.setAngleStart(angleStart);
        player1.setAngleExtent(angleExtent);

        Arc2D player2 = new Arc2D.Float(Arc2D.PIE);
        player2.setFrame(0, 0, aw, ah);
        player2.setAngleStart(angleStart2);
        player2.setAngleExtent(angleExtent2);

        for (int x = 0; x <= 29; x++)
        {
        	for (int y = 0; y <= 19; y++)
        	{
        		g2.drawImage(fld_pics[field[y][x]], x*30, y*30, null);
        	}
        }
        //Player1
        AffineTransform at = AffineTransform.getTranslateInstance(x*30, y*30);
        g2.setColor(Color.yellow);
        g2.drawString(String.copyValueOf(score_p1), 25, 15);
        g2.fill(at.createTransformedShape(player1));
        //Player2
        AffineTransform at2 = AffineTransform.getTranslateInstance(x2*30, y2*30);
        g2.setColor(Color.red);
        g2.drawString(String.copyValueOf(score_p2), 860, 15);
        g2.fill(at2.createTransformedShape(player2));
        //Monsters
        g2.drawImage(fld_pics[30], x_monster1*30, y_monster1*30, null);
        g2.drawImage(fld_pics[31], x_monster2*30, y_monster2*30, null);
        g2.drawImage(fld_pics[32], x_monster3*30, y_monster3*30, null);
        g2.drawImage(fld_pics[33], x_monster4*30, y_monster4*30, null);
    }

    public Graphics2D createGraphics2D(int w, int h) {
        Graphics2D g2 = null;
        if (bimg == null || bimg.getWidth() != w || bimg.getHeight() != h) {
            bimg = (BufferedImage) createImage(w, h);
            reset(w, h);
        } 
        g2 = bimg.createGraphics();
        g2.setBackground(getBackground());
        g2.clearRect(0, 0, w, h);
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);
        return g2;
    }

    public void paint(Graphics g) {
        Dimension d = getSize();
        step(d.width, d.height);
        Graphics2D g2 = createGraphics2D(d.width, d.height);
        drawDemo(d.width, d.height, g2);
        g2.dispose();
        g.drawImage(bimg, 0, 0, this);
        x_border = d.width;
        y_border = d.height;
    }

    public void start() {
        thread = new Thread(this);
        thread.setPriority(Thread.MIN_PRIORITY);
        thread.start();
    }

    public synchronized void stop() {
        thread = null;
    }

    public void run() {
    	int rand = 0;
        Thread me = Thread.currentThread();
        while (thread == me) {
            repaint();
            try {
                thread.sleep(10);
                cnt_time++;
                
                if (respawn_time_p1 > 0)
                {
                	respawn_time_p1--;
                	if (respawn_time_p1 == 1)
                	{
                		x = 1;
                		y = 1;
                	}
                }
                
                if (respawn_time_p2 > 0)
                {
                	respawn_time_p2--;
                	if (respawn_time_p2 == 1)
                	{
                		x2 = 28;
                		y2 = 18;
                	}
                }
                
                if (cnt_time == 30)
                {
                	cnt_time = 0;
                	while (((field[y_monster1 + y_mod_monster1][x_monster1 + x_mod_monster1] != 0) && (field[y_monster1 + y_mod_monster1][x_monster1 + x_mod_monster1] != 1)) || (mov_length_monster1 == 0))
                	{
                		rand = (char) ((Math.round( Math.random()*100000) ) % 10);

                		mov_length_monster1 = (char) (rand + 1);
                		
                		rand = (int) ((Math.round( Math.random()*100000) ) % 4);
                		
                		switch (rand)
                		{
                			case 0:
                				x_mod_monster1 = -1;
                				y_mod_monster1 = 0;
                				break;
                			case 1:
                				x_mod_monster1 = 1;
                				y_mod_monster1 = 0;
                    			break;
                			case 2:
                				x_mod_monster1 = 0;
                				y_mod_monster1 = -1;
                    			break;
                			case 3:
                				x_mod_monster1 = 0;
                				y_mod_monster1 = 1;
                    			break;
                		}
                	}
                	while (((field[y_monster2 + y_mod_monster2][x_monster2 + x_mod_monster2] != 0) && (field[y_monster2 + y_mod_monster2][x_monster2 + x_mod_monster2] != 1)) || (mov_length_monster2 == 0))
                	{
                		rand = (char) ((Math.round( Math.random()*100000) ) % 10);

                		mov_length_monster2 = (char) (rand + 1);
                		
                		rand = (int) ((Math.round( Math.random()*100000) ) % 4);
                		
                		switch (rand)
                		{
                			case 0:
                				x_mod_monster2 = -1;
                				y_mod_monster2 = 0;
                				break;
                			case 1:
                				x_mod_monster2 = 1;
                				y_mod_monster2 = 0;
                    			break;
                			case 2:
                				x_mod_monster2 = 0;
                				y_mod_monster2 = -1;
                    			break;
                			case 3:
                				x_mod_monster2 = 0;
                				y_mod_monster2 = 1;
                    			break;
                		}
                	}
                	while (((field[y_monster3 + y_mod_monster3][x_monster3 + x_mod_monster3] != 0) && (field[y_monster3 + y_mod_monster3][x_monster3 + x_mod_monster3] != 1)) || (mov_length_monster3 == 0))
                	{
                		rand = (char) ((Math.round( Math.random()*100000) ) % 10);

                		mov_length_monster3 = (char) (rand + 1);
                		
                		rand = (int) ((Math.round( Math.random()*100000) ) % 4);
                		
                		switch (rand)
                		{
                			case 0:
                				x_mod_monster3 = -1;
                				y_mod_monster3 = 0;
                				break;
                			case 1:
                				x_mod_monster3 = 1;
                				y_mod_monster3 = 0;
                    			break;
                			case 2:
                				x_mod_monster3 = 0;
                				y_mod_monster3 = -1;
                    			break;
                			case 3:
                				x_mod_monster3 = 0;
                				y_mod_monster3 = 1;
                    			break;
                		}
                	}
                	while (((field[y_monster4 + y_mod_monster4][x_monster4 + x_mod_monster4] != 0) && (field[y_monster4 + y_mod_monster4][x_monster4 + x_mod_monster4] != 1)) || (mov_length_monster4 == 0))
                	{
                		rand = (char) ((Math.round( Math.random()*100000) ) % 10);

                		mov_length_monster4 = (char) (rand + 1);
                		
                		rand = (int) ((Math.round( Math.random()*100000) ) % 4);
                		
                		switch (rand)
                		{
                			case 0:
                				x_mod_monster4 = -1;
                				y_mod_monster4 = 0;
                				break;
                			case 1:
                				x_mod_monster4 = 1;
                				y_mod_monster4 = 0;
                    			break;
                			case 2:
                				x_mod_monster4 = 0;
                				y_mod_monster4 = -1;
                    			break;
                			case 3:
                				x_mod_monster4 = 0;
                				y_mod_monster4 = 1;
                    			break;
                		}
                	}
                	x_monster1 = x_monster1 + x_mod_monster1;
            		y_monster1 = y_monster1 + y_mod_monster1;
            		mov_length_monster1--;
            		
            		x_monster2 = x_monster2 + x_mod_monster2;
            		y_monster2 = y_monster2 + y_mod_monster2;
            		mov_length_monster2--;
            		
            		x_monster3 = x_monster3 + x_mod_monster3;
            		y_monster3 = y_monster3 + y_mod_monster3;
            		mov_length_monster3--;
            		
            		x_monster4 = x_monster4 + x_mod_monster4;
            		y_monster4 = y_monster4 + y_mod_monster4;
            		mov_length_monster4--;
            		
            		if (((x == x_monster1) && (y == y_monster1)) || ((x == x_monster2) && (y == y_monster2)) || ((x == x_monster3) && (y == y_monster3)) || ((x == x_monster4) && (y == y_monster4)))
            		{
            			respawn_time_p1 = 500;
            			die_sound.play();
            			x = 10;
            			y = 5;
            		}
            		if (((x2 == x_monster1) && (y2 == y_monster1)) || ((x2 == x_monster2) && (y2 == y_monster2)) || ((x2 == x_monster3) && (y2 == y_monster3)) || ((x2 == x_monster4) && (y2 == y_monster4)))
            		{
            			respawn_time_p2 = 500;
            			die_sound.play();
            			x2 = 15;
            			y2 = 12;
            		}
                }
            } catch (InterruptedException e) { break; }
        }
        thread = null;
    }

    public static void main(String argv[]) {
        final Arcs demo = new Arcs();
        demo.init();
        Frame f = new Frame("Freshman - v02");
        f.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {System.exit(0);}
            public void windowDeiconified(WindowEvent e) { demo.start(); }
            public void windowIconified(WindowEvent e) { demo.stop(); }
        });
        f.add(demo);
        f.pack();
        f.setSize(new Dimension(920, 630));
        f.show();
        f.addKeyListener(demo);
        demo.start();
    }
	@Override
	public void keyPressed(KeyEvent e) {
	    int keyCode = e.getKeyCode();
	    
	    switch( keyCode ) { 
// Player 1:
	    	case KeyEvent.VK_UP:
	            // handle up 
	        	direction = UP;
	        	if ((field[y-1][x] == 0) || (field[y-1][x] == 1))
	        	{
	        		y = y - 1;
	        	}
	        	angleStart = 135;
	        	angleExtent = 270;
	            break;
	        case KeyEvent.VK_DOWN:
	            // handle down 
	        	if ((field[y+1][x] == 0) || (field[y+1][x] == 1))
	        	{
	        		y = y + 1;
	        	}
	        	direction = DOWN;
	        	angleStart = 315;
	        	angleExtent = 270;
	            break;
	        case KeyEvent.VK_LEFT:
	            // handle left
	        	if ((field[y][x-1] == 0) || (field[y][x-1] == 1))
	        	{
	        		x = x - 1;
	        	}
	        	direction = BACKWARD;
	        	angleStart = 225;
	        	angleExtent = 270;
	            break;
	        case KeyEvent.VK_RIGHT :
	            // handle right
	        	if ((field[y][x+1] == 0) || (field[y][x+1] == 1))
	        	{
	        		x = x + 1;
	        	}
	        	angleStart = 45;
	        	angleExtent = 270;
	        	//mouth = CLOSE;
	        	direction = FORWARD;
	            break;
// Player 2:	            
	    	case KeyEvent.VK_W:
	            // handle up 
	        	direction2 = UP;
	        	if ((field[y2-1][x2] == 0) || (field[y2-1][x2] == 1))
	        	{
	        		y2 = y2 - 1;
	        	}
	        	angleStart2 = 135;
	        	angleExtent2 = 270;
	            break;
	        case KeyEvent.VK_S:
	            // handle down 
	        	if ((field[y2+1][x2] == 0) || (field[y2+1][x2] == 1))
	        	{
	        		y2 = y2 + 1;
	        	}
	        	direction2 = DOWN;
	        	angleStart2 = 315;
	        	angleExtent2 = 270;
	            break;
	        case KeyEvent.VK_A:
	            // handle left
	        	if ((field[y2][x2-1] == 0) || (field[y2][x2-1] == 1))
	        	{
	        		x2 = x2- 1;
	        	}
	        	direction2 = BACKWARD;
	        	angleStart2 = 225;
	        	angleExtent2 = 270;
	            break;
	        case KeyEvent.VK_D :
	            // handle right
	        	if ((field[y2][x2+1] == 0) || (field[y2][x2+1] == 1))
	        	{
	        		x2 = x2 + 1;
	        	}
	        	angleStart2 = 45;
	        	angleExtent2 = 270;
	        	//mouth = CLOSE;
	        	direction2 = FORWARD;
	            break;
	            
	        case KeyEvent.VK_M:
	        	// Music on/off
	        	if (music_on == true)
	        	{
	        		music_on = false;
	        		theme_song.stop();
	        	}
	        	else
	        	{
	        		music_on = true;
	        		theme_song.loop();
	        	}
	        	
	     }
	    
	    if (field[y][x] == 1)
	    {
	    	eat_sound.play();
	    	field[y][x] = 0;
	    	score_p1[2]++;
	    	if (score_p1[2] == 58)
	    	{
	    		score_p1[2] = 48;
	    		score_p1[1]++;
	    	}
	    	if (score_p1[1] == 58)
	    	{
	    		score_p1[1] = 48;
	    		score_p1[0]++;
	    	}
	    }
	    if (field[y2][x2] == 1)
	    {
	    	eat_sound.play();
	    	field[y2][x2] = 0;
	    	score_p2[2]++;
	    	if (score_p2[2] == 58)
	    	{
	    		score_p2[2] = 48;
	    		score_p2[1]++;
	    	}
	    	if (score_p2[1] == 58)
	    	{
	    		score_p2[1] = 48;
	    		score_p2[0]++;
	    	}
	    }
	    
	    if (((x == x_monster1) && (y == y_monster1)) || ((x == x_monster2) && (y == y_monster2)) || ((x == x_monster3) && (y == y_monster3)) || ((x == x_monster4) && (y == y_monster4)))
		{
			respawn_time_p1 = 500;
			die_sound.play();
			x = 10;
			y = 5;
		}
		if (((x2 == x_monster1) && (y2 == y_monster1)) || ((x2 == x_monster2) && (y2 == y_monster2)) || ((x2 == x_monster3) && (y2 == y_monster3)) || ((x2 == x_monster4) && (y2 == y_monster4)))
		{
			respawn_time_p2 = 500;
			die_sound.play();
			x2 = 15;
			y2 = 12;
		}
	}
	@Override
	public void keyReleased(KeyEvent arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void keyTyped(KeyEvent arg0) {
		// TODO Auto-generated method stub
		
	}
}

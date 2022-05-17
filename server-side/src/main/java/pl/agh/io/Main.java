package pl.agh.io;
import java.util.*;


public class Main {
    public static void main(String[] args) {
        PathFinder pathFinder = new PathFinder(1);
        List<String> traversal = pathFinder.findGyms();
        System.out.println(traversal);
    }
}

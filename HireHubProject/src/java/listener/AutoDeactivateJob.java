package listener;

import dal.NotificationDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AutoDeactivateJob implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        scheduler = Executors.newSingleThreadScheduledExecutor();

        scheduler.scheduleAtFixedRate(() -> {
            System.out.println("RUN AUTO DEACTIVATE...");
            new NotificationDAO().autoDeactivateUsers();
        }, 0, 1, TimeUnit.MINUTES); // chạy mỗi phút
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        scheduler.shutdown();
    }
}
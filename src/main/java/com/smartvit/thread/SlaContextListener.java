package com.smartvit.thread;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

/**
 * Servlet Context Listener to manage background Multithreading lifecycle in Tomcat.
 * Starts SLA monitoring daemon thread when application initializes,
 * and gracefully stops thread pool on application shutdown.
 */
@WebListener
public class SlaContextListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(SlaContextListener.class.getName());

    private ScheduledExecutorService scheduler;
    private SlaMonitoringThread slaWorker;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("[Smart VIT Lifecycle] Initializing web application context & starting background SLA threads...");

        slaWorker = new SlaMonitoringThread(60000); // Audit SLA every 60 seconds
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "SmartVIT-SLA-Monitor-Thread");
            t.setDaemon(true);
            return t;
        });

        // Schedule periodic SLA audit task
        scheduler.scheduleAtFixedRate(slaWorker, 10, 60, TimeUnit.SECONDS);
        LOGGER.info("[Smart VIT Lifecycle] Background SLA Monitoring Thread scheduled successfully.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("[Smart VIT Lifecycle] Shutting down web application context & background threads...");
        if (slaWorker != null) {
            slaWorker.stopWorker();
        }
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
        LOGGER.info("[Smart VIT Lifecycle] Background threads stopped cleanly.");
    }
}

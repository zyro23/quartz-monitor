package grails.plugin.quartzmonitor

import grails.plugins.quartz.GrailsJobFactory

import org.quartz.Job
import org.quartz.JobExecutionContext
import org.quartz.JobExecutionException

/**
 * Quartz Job implementation that invokes execute() on the GrailsTaskClassJob instance whilst recording the time
 */
class QuartzDisplayJob implements Job {
    
    GrailsJobFactory.GrailsJob job
    Map<String, Object> jobDetails
    private def sessionFactory

    QuartzDisplayJob(GrailsJobFactory.GrailsJob job, Map<String, Object> jobDetails, def sessionFactory) {
        this.job = job
        this.jobDetails = jobDetails
        this.sessionFactory = sessionFactory
    }

    void execute(final JobExecutionContext context) throws JobExecutionException {
        jobDetails.clear()
        jobDetails.lastRun = new Date()
        jobDetails.status = "running"
        long start = System.currentTimeMillis()
        try {
            job.execute(context)
        } catch (Throwable e) {
            jobDetails.error = e.message
            jobDetails.status = "error"
            if (e instanceof JobExecutionException) {
                throw e
            }
            throw new JobExecutionException(e.message, e)
        }
        jobDetails.status = "complete"
        jobDetails.duration = System.currentTimeMillis() - start
    }

}

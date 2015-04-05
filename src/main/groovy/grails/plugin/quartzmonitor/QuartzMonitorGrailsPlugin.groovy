package grails.plugin.quartzmonitor

import grails.plugins.*

class QuartzMonitorGrailsPlugin extends Plugin {

    def loadAfter = ["quartz"]
    def grailsVersion = "3.0.0 > *"
    def profiles = ["web"]
    def title = "Quartz Monitor"
    def author = "James Cook"
    def authorEmail = "grails@jamescookie.com"
    def description = "One clear and concise page that enables you to administer all your Quartz jobs"
    def documentation = "http://grails.org/plugin/quartz-monitor"
    def license = "APACHE"
    def scm = [url: "http://github.com/jamescookie/quartz-monitor"]
    def issueManagement = [system: "GITHUB", url: "http://github.com/jamescookie/quartz-monitor/issues"]
    
    Closure doWithSpring() {
        return { ->
            quartzJobFactory(QuartzMonitorJobFactory) {
                if (manager?.hasGrailsPlugin("hibernate")) {
                    sessionFactory = ref("sessionFactory")
                }
            }
        }
    }

}

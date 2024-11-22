module TimelineService
  class Constants
    RECORDS_TIME_WINDOW = 1.week

    # Cache get latest following for 3 minutes
    # with assumption people has possibility to frequently
    # do follow other people so that user can see new feed
    # in timeline almost immediately
    FOLLOWING_IDS_CACHE_DURATION = 3.minutes

    # Cache timeline duration for 1 hour
    # with assumption people track sleeping time either
    # when take a nap or take a night sleep
    # it does not need to frequently do query to sleep_records table
    TIMELINE_CACHE_DURATION = 1.hour
  end
end

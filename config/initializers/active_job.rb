Rails.configuration.active_job.queue_adapter = Rails.env.test? ? :inline : :async

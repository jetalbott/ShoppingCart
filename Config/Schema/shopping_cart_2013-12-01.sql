# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: ubuntu (MySQL 5.5.34-0ubuntu0.12.04.1)
# Database: shopping_cart
# Generation Time: 2013-12-01 22:30:07 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table t_activities
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activities`;

CREATE TABLE `t_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) NOT NULL,
  `activity_template_id` int(11) NOT NULL,
  `index` int(11) NOT NULL,
  `start_timestamp` datetime DEFAULT NULL,
  `completion_timestamp` datetime DEFAULT NULL,
  `name` char(100) NOT NULL,
  `import_id` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `delete_notification_timestamp` datetime DEFAULT NULL,
  `is_private` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_groups_t_activities_FK1` (`activity_group_id`),
  KEY `t_activity_templates_t_activities_FK1` (`activity_template_id`),
  KEY `t_activities_agid_atid_idx` (`activity_group_id`,`activity_template_id`),
  CONSTRAINT `t_activity_groups_t_activities_FK1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_templates_t_activities_FK1` FOREIGN KEY (`activity_template_id`) REFERENCES `t_activity_templates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_appointments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_appointments`;

CREATE TABLE `t_activity_appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL,
  `workflow_step_id` int(11) DEFAULT NULL,
  `scheduled_start_timestamp` datetime DEFAULT NULL,
  `due_timestamp` datetime DEFAULT NULL,
  `scheduled_end_timestamp` datetime DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '0',
  `is_private` tinyint(1) DEFAULT '0',
  `invite_user_ids` varchar(50) DEFAULT NULL,
  `invitations_sent` varchar(50) DEFAULT NULL,
  `notification_offset_days` int(11) DEFAULT NULL,
  `notification_sent` datetime DEFAULT NULL,
  `notification_sent_count` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  KEY `workflow_step_id` (`workflow_step_id`),
  KEY `activity_fk` (`activity_id`),
  KEY `workflow_step_fk` (`workflow_step_id`),
  CONSTRAINT `activity_fk` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `workflow_step_fk` FOREIGN KEY (`workflow_step_id`) REFERENCES `t_workflow_steps` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_evaluation_indicator_comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_evaluation_indicator_comments`;

CREATE TABLE `t_activity_evaluation_indicator_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `activity_evaluation_indicator_id` int(11) NOT NULL,
  `is_shared` tinyint(4) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_evaluation_indicator_fk` (`activity_evaluation_indicator_id`),
  CONSTRAINT `activity_evaluation_indicator_fk` FOREIGN KEY (`activity_evaluation_indicator_id`) REFERENCES `t_activity_evaluation_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_activity_evaluation_indicator_subitems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_evaluation_indicator_subitems`;

CREATE TABLE `t_activity_evaluation_indicator_subitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_evaluation_id` int(11) NOT NULL,
  `indicator_proficiency_level_subitem_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `aeis_u1` (`activity_evaluation_id`,`indicator_proficiency_level_subitem_id`),
  KEY `indicator_proficiency_level_subitem_id` (`indicator_proficiency_level_subitem_id`),
  CONSTRAINT `t_activity_evaluation_indicator_subitems_ibfk_1` FOREIGN KEY (`activity_evaluation_id`) REFERENCES `t_activity_evaluations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_activity_evaluation_indicator_subitems_ibfk_2` FOREIGN KEY (`indicator_proficiency_level_subitem_id`) REFERENCES `t_indicator_proficiency_level_subitems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_evaluation_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_evaluation_indicators`;

CREATE TABLE `t_activity_evaluation_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_evaluation_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `proficiency_level_id` int(11) NOT NULL,
  `comment` varchar(10) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `is_finalized` tinyint(1) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_evaluations_t_activity_evaluation_indicators_FK1` (`activity_evaluation_id`),
  KEY `t_activity_evaluation_indicators_aeid_iid_plid_idx` (`activity_evaluation_id`,`indicator_id`,`proficiency_level_id`),
  CONSTRAINT `t_activity_evaluations_t_activity_evaluation_indicators_FK1` FOREIGN KEY (`activity_evaluation_id`) REFERENCES `t_activity_evaluations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_evaluations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_evaluations`;

CREATE TABLE `t_activity_evaluations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `shared_to_observers` tinyint(1) NOT NULL DEFAULT '0',
  `shared_to_learner` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activities_t_activity_evaluations_FK1` (`activity_id`),
  CONSTRAINT `t_activities_t_activity_evaluations_FK1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_evidence
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_evidence`;

CREATE TABLE `t_activity_evidence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_shared` tinyint(4) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`),
  KEY `t_activities_t_activity_comments_FK1` (`activity_id`),
  CONSTRAINT `t_activities_t_activity_comments_FK1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_feedback`;

CREATE TABLE `t_activity_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `feedback` text,
  `feedback_time` datetime DEFAULT NULL,
  `next_step` text,
  `next_step_time` datetime DEFAULT NULL,
  `private_notes` text,
  `private_notes_time` datetime DEFAULT NULL,
  `is_shared` tinyint(4) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_activities_feedback_user_id_activity_id_UK1` (`user_id`,`activity_id`),
  KEY `t_activities_feedback_FK1` (`activity_id`),
  CONSTRAINT `t_activity_feedback_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_activity_group_auto_participants
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_auto_participants`;

CREATE TABLE `t_activity_group_auto_participants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `for_user_id` int(11) DEFAULT NULL,
  `participant_user_id` int(11) DEFAULT NULL,
  `added_by_user_id` int(11) DEFAULT NULL,
  `access_role_id` int(11) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  `deleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `for_user_id` (`for_user_id`),
  KEY `participant_user_id` (`participant_user_id`),
  CONSTRAINT `t_activity_group_auto_participants_ibfk_1` FOREIGN KEY (`for_user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `t_activity_group_auto_participants_ibfk_2` FOREIGN KEY (`participant_user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_activity_group_feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_feedback`;

CREATE TABLE `t_activity_group_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `feedback` text,
  `feedback_time` datetime DEFAULT NULL,
  `next_step` text,
  `next_step_time` datetime DEFAULT NULL,
  `private_notes` text,
  `private_notes_time` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_group_id` (`activity_group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_activity_group_feedback_ibfk_1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_activity_group_feedback_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_group_final_rating_subitems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_final_rating_subitems`;

CREATE TABLE `t_activity_group_final_rating_subitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `indicator_proficiency_level_subitem_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_group_id` (`activity_group_id`),
  KEY `user_id` (`user_id`),
  KEY `indicator_proficiency_level_subitem_id` (`indicator_proficiency_level_subitem_id`),
  CONSTRAINT `t_activity_group_final_rating_subitems_ibfk_1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_activity_group_final_rating_subitems_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_activity_group_final_rating_subitems_ibfk_3` FOREIGN KEY (`indicator_proficiency_level_subitem_id`) REFERENCES `t_indicator_proficiency_level_subitems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_group_final_ratings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_final_ratings`;

CREATE TABLE `t_activity_group_final_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `proficiency_level_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_group_id` (`activity_group_id`,`indicator_id`),
  KEY `t_activity_groups_t_activity_group_final_ratings_FK1` (`activity_group_id`),
  CONSTRAINT `t_activity_groups_t_activity_group_final_ratings_FK1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_group_participants
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_participants`;

CREATE TABLE `t_activity_group_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) NOT NULL,
  `participant_user_id` int(11) DEFAULT NULL,
  `access_role_id` int(11) NOT NULL,
  `added_by_user_id` int(11) DEFAULT NULL,
  `completed_timestamp` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agp_u1` (`activity_group_id`,`participant_user_id`),
  KEY `t_user_id_fk` (`participant_user_id`),
  KEY `agp_roles` (`access_role_id`),
  KEY `agp_added_by_users` (`added_by_user_id`),
  CONSTRAINT `agp_added_by_users` FOREIGN KEY (`added_by_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `agp_roles` FOREIGN KEY (`access_role_id`) REFERENCES `t_roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_group_participants_ibfk_1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_user_id_fk` FOREIGN KEY (`participant_user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_group_requests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_requests`;

CREATE TABLE `t_activity_group_requests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `activity_group_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '{ 1 : ''unassigned'', 2 : ''pending'',  3 : ''accepted'', 4 : ''rejected'' }',
  `to_user_id` int(11) DEFAULT NULL,
  `by_user_id` int(11) DEFAULT NULL,
  `message` text,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_group_id` (`activity_group_id`),
  KEY `to_user_id` (`to_user_id`),
  KEY `by_user_id` (`by_user_id`),
  CONSTRAINT `t_activity_group_requests_ibfk_1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`),
  CONSTRAINT `t_activity_group_requests_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `t_users` (`id`),
  CONSTRAINT `t_activity_group_requests_ibfk_3` FOREIGN KEY (`by_user_id`) REFERENCES `t_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_activity_group_template_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_template_roles`;

CREATE TABLE `t_activity_group_template_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `activity_group_template_id` int(11) DEFAULT NULL,
  `can_schedule` tinyint(1) DEFAULT '0',
  `can_take` tinyint(1) DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_group_template_roles_1` (`role_id`),
  KEY `t_activity_group_template_roles_2` (`activity_group_template_id`),
  CONSTRAINT `t_activity_group_template_roles_1_constraint` FOREIGN KEY (`role_id`) REFERENCES `t_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_group_template_roles_2_constraint` FOREIGN KEY (`activity_group_template_id`) REFERENCES `t_activity_group_templates` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_activity_group_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_group_templates`;

CREATE TABLE `t_activity_group_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `name` char(40) NOT NULL,
  `question_pool_id` int(11) DEFAULT NULL,
  `scheduling_index` int(2) DEFAULT NULL,
  `is_formal` tinyint(1) NOT NULL DEFAULT '0',
  `enable_share_evidence_prompt` tinyint(1) NOT NULL DEFAULT '0',
  `enable_share_rating_promp` tinyint(1) NOT NULL DEFAULT '0',
  `enable_complete_prompt` tinyint(1) NOT NULL DEFAULT '0',
  `allow_add_activity` tinyint(1) DEFAULT '0',
  `allow_aggregation` tinyint(1) DEFAULT '0',
  `show_participants_as_anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `prevent_scheduling` tinyint(1) NOT NULL DEFAULT '0',
  `allow_learner_scheduling` tinyint(1) DEFAULT NULL,
  `allow_defer_coach_selection` tinyint(1) DEFAULT NULL,
  `enable_locking` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `enable_signing` tinyint(1) NOT NULL DEFAULT '0',
  `enable_role_sharing` tinyint(1) NOT NULL DEFAULT '0',
  `org_id` int(11) DEFAULT NULL,
  `role_id` int(11) NOT NULL DEFAULT '2003',
  `is_mobile` tinyint(1) NOT NULL DEFAULT '0',
  `is_meeting` tinyint(1) NOT NULL DEFAULT '0',
  `allow_practice` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_pool_id` (`question_pool_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `t_activity_group_templates_ibfk_1` FOREIGN KEY (`question_pool_id`) REFERENCES `t_question_pool_templates` (`id`),
  CONSTRAINT `t_activity_group_templates_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `t_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_groups`;

CREATE TABLE `t_activity_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_template_id` int(11) NOT NULL,
  `name` char(80) NOT NULL,
  `creator_user_id` int(11) DEFAULT NULL,
  `start_timestamp` datetime DEFAULT NULL,
  `completion_timestamp` datetime DEFAULT NULL,
  `question_pool_attempt_id` int(11) DEFAULT NULL,
  `rubric_id` int(11) DEFAULT NULL,
  `import_id` varchar(50) DEFAULT NULL,
  `is_practice` tinyint(1) NOT NULL DEFAULT '0',
  `allow_aggregation` tinyint(1) DEFAULT '0',
  `aggregation_start_timestamp` datetime DEFAULT NULL,
  `aggregation_end_timestamp` datetime DEFAULT NULL,
  `observation_modified` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `delete_notification_timestamp` datetime DEFAULT NULL,
  `locked` datetime DEFAULT NULL,
  `school_year_id` int(11) DEFAULT NULL,
  `emails_tracker` text,
  PRIMARY KEY (`id`),
  KEY `t_activity_group_templates_t_activity_groups_FK1` (`activity_group_template_id`),
  KEY `deleted_index` (`deleted`),
  KEY `question_pool_attempt_id` (`question_pool_attempt_id`),
  KEY `rubric_id` (`rubric_id`),
  KEY `ag_creator_user_id` (`creator_user_id`),
  CONSTRAINT `ag_creator_user_id` FOREIGN KEY (`creator_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_groups_ibfk_1` FOREIGN KEY (`question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`),
  CONSTRAINT `t_activity_groups_ibfk_2` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_indicators`;

CREATE TABLE `t_activity_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activities_t_activity_indicators_FK1` (`activity_id`),
  KEY `fk_activity` (`activity_id`),
  KEY `fk_activity_indicators_indicator` (`indicator_id`),
  CONSTRAINT `fk_activity` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_activity_indicators_indicator_constraint` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_activities_t_activity_indicators_FK1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_indicators_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_indicators_copy`;

CREATE TABLE `t_activity_indicators_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activities_t_activity_indicators_FK1` (`activity_id`),
  KEY `fk_activity` (`activity_id`),
  CONSTRAINT `t_activity_indicators_copy_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_indicators_copy_ibfk_2` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_required_resources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_required_resources`;

CREATE TABLE `t_activity_required_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `question_pool_attempt_id` int(11) DEFAULT NULL,
  `snapshot_id` int(11) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `required_resource_id` int(11) NOT NULL,
  `local_content_value` text,
  `is_shared` smallint(6) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activities_t_activity_required_resources_FK1` (`activity_id`),
  KEY `t___required_resource_s_t_activity_required_resources_FK1` (`required_resource_id`),
  KEY `t__user_id` (`user_id`),
  KEY `u_question_pool_attempts` (`question_pool_attempt_id`),
  KEY `t___arr_to_contents_idx` (`content_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `snapshot_id` FOREIGN KEY (`snapshot_id`) REFERENCES `t_snapshots` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_activities_t_activity_required_resources_FK1` FOREIGN KEY (`activity_id`) REFERENCES `t_activities` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t__user_id` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t___arr_to_contents` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `t___required_resource_s_t_activity_required_resources_FK1` FOREIGN KEY (`required_resource_id`) REFERENCES `t_required_resources` (`id`),
  CONSTRAINT `u_question_pool_attempts` FOREIGN KEY (`question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_template_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_template_indicators`;

CREATE TABLE `t_activity_template_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_template_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_templates_t_activity_template_indicators_FK1` (`activity_template_id`),
  KEY `fk_indicator` (`indicator_id`),
  CONSTRAINT `fk_indicator_constraint` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_activity_templates_t_activity_template_indicators_FK1` FOREIGN KEY (`activity_template_id`) REFERENCES `t_activity_templates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_templates`;

CREATE TABLE `t_activity_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_group_template_id` int(11) DEFAULT NULL,
  `name` char(80) NOT NULL,
  `description` char(255) DEFAULT NULL,
  `is_customizable` tinyint(4) NOT NULL,
  `index` int(11) NOT NULL,
  `scheduling_index_field` int(11) NOT NULL,
  `first_activity_workflow_step` int(11) DEFAULT NULL,
  `central_activity_workflow_step` int(11) DEFAULT NULL,
  `is_multiple_allowed` tinyint(4) NOT NULL,
  `allow_add_activity` tinyint(1) DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_group_templates_t_activity_templates_FK1` (`activity_group_template_id`),
  KEY `t_workflow_steps_t_activity_templates_FK1` (`first_activity_workflow_step`),
  KEY `t_workflow_steps_t_activity_templates_FK2` (`central_activity_workflow_step`),
  CONSTRAINT `t_activity_group_templates_t_activity_templates_FK1` FOREIGN KEY (`activity_group_template_id`) REFERENCES `t_activity_group_templates` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_workflow_steps_t_activity_templates_FK1` FOREIGN KEY (`first_activity_workflow_step`) REFERENCES `t_workflow_steps` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `t_workflow_steps_t_activity_templates_FK2` FOREIGN KEY (`central_activity_workflow_step`) REFERENCES `t_workflow_steps` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_activity_workflow_steps
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_activity_workflow_steps`;

CREATE TABLE `t_activity_workflow_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `activity_appointment_id` int(11) NOT NULL,
  `started_timestamp` datetime DEFAULT NULL,
  `completion_timestamp` datetime DEFAULT NULL,
  `last_update_timestamp` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_appointment_id` (`activity_appointment_id`),
  KEY `activity_appointment_fk` (`activity_appointment_id`),
  CONSTRAINT `activity_appointment_fk` FOREIGN KEY (`activity_appointment_id`) REFERENCES `t_activity_appointments` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_artifacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_artifacts`;

CREATE TABLE `t_artifacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `json_source` varchar(255) DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `artifacts_u1` (`user_id`,`content_id`),
  KEY `content_id` (`content_id`),
  CONSTRAINT `t_artifacts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_artifacts_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_attributes`;

CREATE TABLE `t_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL,
  `type_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_organizations_t_attributes_FK1` (`org_id`),
  CONSTRAINT `t_organizations_t_attributes_FK1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_blacklisted_emails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_blacklisted_emails`;

CREATE TABLE `t_blacklisted_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `reason` varchar(45) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `blocked_emails` (`email`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_board_posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_board_posts`;

CREATE TABLE `t_board_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) DEFAULT NULL,
  `object_id_type` varchar(45) DEFAULT NULL,
  `event_type` varchar(45) NOT NULL,
  `source_user_id` int(11) DEFAULT NULL,
  `xid` varchar(45) DEFAULT NULL,
  `data` text,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_board_posts_t_users1` (`source_user_id`),
  KEY `xid_index` (`xid`),
  KEY `object_id_type_object_id_index` (`object_id`,`object_id_type`),
  CONSTRAINT `fk_t_board_posts_t_users1` FOREIGN KEY (`source_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_bulk_actions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_bulk_actions`;

CREATE TABLE `t_bulk_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL DEFAULT 'UNKNOWN',
  `status` varchar(25) NOT NULL DEFAULT 'PENDING',
  `memo` text,
  `file_name` varchar(150) DEFAULT NULL,
  `total_errors` int(11) DEFAULT NULL,
  `lines_processed` int(11) DEFAULT NULL,
  `data` longtext,
  `started` datetime DEFAULT NULL,
  `completed` datetime DEFAULT NULL,
  `aborted` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_bulk_action_user_id_fk` (`user_id`),
  CONSTRAINT `t_bulk_action_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_coach_trainees
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_coach_trainees`;

CREATE TABLE `t_coach_trainees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coach_user_id` int(11) NOT NULL,
  `trainee_user_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_users_t_coach_trainees_FK1` (`coach_user_id`),
  KEY `t_users_t_coach_trainees_FK2` (`trainee_user_id`),
  CONSTRAINT `t_users_t_coach_trainees_FK1` FOREIGN KEY (`coach_user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_users_t_coach_trainees_FK2` FOREIGN KEY (`trainee_user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_comments`;

CREATE TABLE `t_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xid` varchar(45) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_comments_t_users1` (`user_id`),
  KEY `xid_index` (`xid`),
  CONSTRAINT `fk_t_comments_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_content_annotations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_content_annotations`;

CREATE TABLE `t_content_annotations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `comment` text,
  `indicators` varchar(60) DEFAULT NULL,
  `start` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `resource_content_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_content_annotations_t_contents1` (`content_id`),
  KEY `fk_t_content_annotations_t_resource_contents1` (`resource_content_id`),
  CONSTRAINT `fk_t_content_annotations_t_contents1` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_content_annotations_t_resource_contents1` FOREIGN KEY (`resource_content_id`) REFERENCES `t_resource_contents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_content_thumbnails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_content_thumbnails`;

CREATE TABLE `t_content_thumbnails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thumbnail_path` varchar(150) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `thumbnail_content_id_fk` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_content_vendors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_content_vendors`;

CREATE TABLE `t_content_vendors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(127) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_contents`;

CREATE TABLE `t_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_vendor_id` int(11) DEFAULT NULL,
  `mime_type` varchar(255) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `bucket` int(11) DEFAULT NULL,
  `directory_path` varchar(255) DEFAULT NULL,
  `original_path` varchar(255) DEFAULT NULL,
  `vendor_path` varchar(255) DEFAULT NULL,
  `html_path` varchar(255) DEFAULT NULL,
  `crocodoc_uuid` varchar(200) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `crocodoc_error` varchar(45) DEFAULT NULL,
  `processing_started` datetime DEFAULT NULL COMMENT 'Keeps a record of the timestamp when processing is initiated on this content',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_encoded_videos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_encoded_videos`;

CREATE TABLE `t_encoded_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `audio_codec` varchar(80) NOT NULL,
  `video_codec` varchar(80) NOT NULL,
  `height` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `relative_path` varchar(255) DEFAULT NULL,
  `content_id` int(11) NOT NULL,
  `encode_status_keys` varchar(80) DEFAULT NULL,
  `encoder_vendor_id` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `view_tag` varchar(100) DEFAULT NULL,
  `duration_ms` int(11) DEFAULT NULL,
  `format` varchar(45) NOT NULL,
  `encoder_stdout` text,
  `status` varchar(100) NOT NULL,
  `snapshot_interval` int(11) DEFAULT NULL,
  `pic_relative_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contents_fk` (`content_id`),
  CONSTRAINT `contents_fk` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_evidence
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_evidence`;

CREATE TABLE `t_evidence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_evidence_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `activity_required_resource_id` int(11) NOT NULL,
  `value` text,
  `video_time` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `comment` text,
  `is_scripted` tinyint(4) NOT NULL DEFAULT '0',
  `video_timestamp_ms` int(11) DEFAULT NULL,
  `evidence_snapshot_id` int(11) DEFAULT NULL,
  `duration_ms` int(11) DEFAULT NULL,
  `is_reference_evidence` tinyint(4) DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_activity_comments_t_comments_FK1` (`activity_evidence_id`),
  KEY `activity_evidence_fk` (`activity_evidence_id`),
  KEY `evidence_snapshot_fk` (`evidence_snapshot_id`),
  KEY `e_user_id` (`user_id`),
  CONSTRAINT `activity_evidence_fk` FOREIGN KEY (`activity_evidence_id`) REFERENCES `t_activity_evidence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `evidence_snapshot_fk` FOREIGN KEY (`evidence_snapshot_id`) REFERENCES `t_evidence_snapshots` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `e_user_id` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_evidence_goals
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_evidence_goals`;

CREATE TABLE `t_evidence_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `evidence_id` int(11) NOT NULL,
  `goal_id` int(11) NOT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_evidence` (`evidence_id`),
  KEY `fk_goals` (`goal_id`),
  CONSTRAINT `fk_evidence_goals_evidence` FOREIGN KEY (`evidence_id`) REFERENCES `t_evidence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_evidence_goals_goals` FOREIGN KEY (`goal_id`) REFERENCES `t_goals` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_evidence_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_evidence_indicators`;

CREATE TABLE `t_evidence_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `evidence_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_evidence` (`evidence_id`),
  KEY `fk_indicator` (`indicator_id`),
  CONSTRAINT `fk_evidence` FOREIGN KEY (`evidence_id`) REFERENCES `t_evidence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_indicator` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_evidence_snapshots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_evidence_snapshots`;

CREATE TABLE `t_evidence_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bucket` int(11) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `full_path` varchar(255) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `evidence_id` int(11) NOT NULL,
  `content_vendor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `evidence` (`evidence_id`),
  KEY `createdby` (`created_by`),
  CONSTRAINT `createdby` FOREIGN KEY (`created_by`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `evidence` FOREIGN KEY (`evidence_id`) REFERENCES `t_evidence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_goal_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_goal_indicators`;

CREATE TABLE `t_goal_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_goal_indicator` (`goal_id`,`indicator_id`),
  KEY `fk_t_goal_indicators_t_goals1` (`goal_id`),
  KEY `fk_t_goal_indicators_t_indicators1` (`indicator_id`),
  CONSTRAINT `fk_t_goal_indicators_t_goals1` FOREIGN KEY (`goal_id`) REFERENCES `t_goals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_goal_indicators_t_indicators1` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_goals
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_goals`;

CREATE TABLE `t_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `creator_user_id` int(11) DEFAULT NULL,
  `goal_question_pool_attempt_id` int(11) DEFAULT NULL,
  `text` text,
  `date_completed` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `date_deleted` datetime DEFAULT NULL,
  `inactive` timestamp NULL DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_goals_t_users1` (`user_id`),
  KEY `fk_t_goals_question_pool_attempts1` (`goal_question_pool_attempt_id`),
  KEY `fk_t_goals_t_users2` (`creator_user_id`),
  CONSTRAINT `fk_t_goals_question_pool_attempts1` FOREIGN KEY (`goal_question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_goals_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_goals_t_users2` FOREIGN KEY (`creator_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_grade_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_grade_levels`;

CREATE TABLE `t_grade_levels` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `code` varchar(10) NOT NULL DEFAULT '',
  `index` int(2) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_imported_coach_trainees
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_imported_coach_trainees`;

CREATE TABLE `t_imported_coach_trainees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `coach_employee_id` varchar(255) DEFAULT NULL,
  `trainee_employee_id` varchar(255) DEFAULT NULL,
  `coach_external_org_id` varchar(255) DEFAULT NULL,
  `trainee_external_org_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_imported_organization_ancestors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_imported_organization_ancestors`;

CREATE TABLE `t_imported_organization_ancestors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_org_id` int(11) NOT NULL,
  `ancestor_org_id` int(11) NOT NULL,
  `distance` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_organizations_t_imported__organization_ancestors_FK1` (`child_org_id`),
  KEY `t_organizations_t_imported__organization_ancestors_FK2` (`ancestor_org_id`),
  CONSTRAINT `t_organizations_t_imported_organization_ancestors_FK1` FOREIGN KEY (`child_org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_organizations_t_imported__organization_ancestors_FK2` FOREIGN KEY (`ancestor_org_id`) REFERENCES `t_organizations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_imported_organizations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_imported_organizations`;

CREATE TABLE `t_imported_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `external_organization_id` int(11) DEFAULT NULL,
  `primary_org_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `region` varchar(255) NOT NULL,
  `common_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `external_orgs_index` (`external_organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_imported_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_imported_users`;

CREATE TABLE `t_imported_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `user_employee_id` varchar(255) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `user_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_ancestors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_ancestors`;

CREATE TABLE `t_indicator_ancestors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_indicator_id` int(11) NOT NULL,
  `ancestor_indicator_id` int(11) NOT NULL,
  `distance` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_indicators_t_indicator_ancestors_FK1` (`ancestor_indicator_id`),
  KEY `t_indicators_t_indicator_ancestors_FK2` (`child_indicator_id`),
  CONSTRAINT `t_indicators_t_indicator_ancestors_FK1` FOREIGN KEY (`ancestor_indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_indicators_t_indicator_ancestors_FK2` FOREIGN KEY (`child_indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_ancestors_bkup
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_ancestors_bkup`;

CREATE TABLE `t_indicator_ancestors_bkup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_indicator_id` int(11) NOT NULL,
  `ancestor_indicator_id` int(11) NOT NULL,
  `distance` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_indicators_t_indicator_ancestors_FK1` (`ancestor_indicator_id`),
  KEY `t_indicators_t_indicator_ancestors_FK2` (`child_indicator_id`),
  CONSTRAINT `t_indicator_ancestors_bkup_ibfk_1` FOREIGN KEY (`ancestor_indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_indicator_ancestors_bkup_ibfk_2` FOREIGN KEY (`child_indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_depth_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_depth_levels`;

CREATE TABLE `t_indicator_depth_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_id` int(11) NOT NULL,
  `name` char(255) NOT NULL,
  `depth` int(11) NOT NULL,
  `summative_selection` tinyint(1) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_rubrics_t_indicator_depth_levels_FK1` (`rubric_id`),
  CONSTRAINT `t_rubrics_t_indicator_depth_levels_FK1` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_depth_levels_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_depth_levels_copy`;

CREATE TABLE `t_indicator_depth_levels_copy` (
  `unique_rubric_id` varchar(100) NOT NULL DEFAULT '',
  `name` char(255) NOT NULL,
  `depth` int(11) NOT NULL,
  `summative_selection` tinyint(1) DEFAULT NULL,
  KEY `t_rubrics_t_indicator_depth_levels_FK1` (`unique_rubric_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_proficiency_level_subitems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_proficiency_level_subitems`;

CREATE TABLE `t_indicator_proficiency_level_subitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `indicator_proficiency_level_id` int(11) NOT NULL,
  `description` text,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `indicator_proficiency_level_id` (`indicator_proficiency_level_id`),
  CONSTRAINT `t_indicator_proficiency_level_subitems_ibfk_1` FOREIGN KEY (`indicator_proficiency_level_id`) REFERENCES `t_indicator_proficiency_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicator_proficiency_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicator_proficiency_levels`;

CREATE TABLE `t_indicator_proficiency_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proficiency_level_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `description` text,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_indicators_t_indicator_proficiency_levels_FK1` (`indicator_id`),
  KEY `t_proficiency_levels_t_indicator_proficiency_levels_FK1` (`proficiency_level_id`),
  CONSTRAINT `t_indicators_t_indicator_proficiency_levels_FK1` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `t_proficiency_levels_t_indicator_proficiency_levels_FK1` FOREIGN KEY (`proficiency_level_id`) REFERENCES `t_proficiency_levels` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicators`;

CREATE TABLE `t_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_id` int(11) NOT NULL,
  `parent_indicator_id` int(11) DEFAULT NULL,
  `indicator_depth_level_id` int(11) NOT NULL,
  `code` char(20) NOT NULL,
  `short_name` char(40) NOT NULL,
  `long_name` text,
  `framework_order` int(11) NOT NULL,
  `priority_order` int(11) DEFAULT NULL,
  `selectable` tinyint(1) DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_code_rubric_id` (`code`,`rubric_id`),
  KEY `t_rubrics_t_indicators_FK1` (`rubric_id`),
  KEY `t_indicators_t_indicators_FK1` (`parent_indicator_id`),
  KEY `t_indicator_depth_levels_t_indicators_FK1` (`indicator_depth_level_id`),
  CONSTRAINT `t_rubrics_t_indicators_FK1` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_indicators_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_indicators_copy`;

CREATE TABLE `t_indicators_copy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `unique_rubric_id` varchar(100) NOT NULL,
  `unique_indicator_id` varchar(100) DEFAULT NULL,
  `parent_unique_indicator_id` varchar(100) DEFAULT NULL,
  `indicator_depth_level_name` varchar(100) NOT NULL DEFAULT '',
  `code` char(20) NOT NULL,
  `long_name` text,
  `framework_order` int(11) NOT NULL,
  `priority_order` int(11) DEFAULT NULL,
  `selectable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_rubrics_t_indicators_FK1` (`unique_rubric_id`),
  KEY `t_indicators_t_indicators_FK1` (`parent_unique_indicator_id`),
  KEY `t_indicator_depth_levels_t_indicators_FK1` (`indicator_depth_level_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_integration_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_integration_users`;

CREATE TABLE `t_integration_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(10) NOT NULL DEFAULT '',
  `provider_id` varchar(20) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `provideruser_integration_FK` (`provider`,`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_mail_queue_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_mail_queue_items`;

CREATE TABLE `t_mail_queue_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `headers` text,
  `recipients` text,
  `subject` text,
  `body` text,
  `sent` datetime DEFAULT NULL,
  `sent_success` tinyint(4) DEFAULT '1',
  `sent_response` text,
  `sent_count` int(11) DEFAULT '0',
  `tag` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `success_key` (`sent_success`),
  KEY `sent_key` (`sent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_mapped_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_mapped_indicators`;

CREATE TABLE `t_mapped_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_indicator_id` int(11) NOT NULL,
  `ref_indicator_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_mapped_indicator` (`org_indicator_id`,`ref_indicator_id`),
  KEY `t_indicators_t_mapped_indicators_FK1` (`org_indicator_id`),
  KEY `t_indicators_t_mapped_indicators_FK2` (`ref_indicator_id`),
  CONSTRAINT `t_indicators_t_mapped_indicators_FK1` FOREIGN KEY (`org_indicator_id`) REFERENCES `t_indicators` (`id`),
  CONSTRAINT `t_indicators_t_mapped_indicators_FK2` FOREIGN KEY (`ref_indicator_id`) REFERENCES `t_indicators` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_mobile_evidence_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_mobile_evidence_log`;

CREATE TABLE `t_mobile_evidence_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `evidence_id` int(11) NOT NULL,
  `json` text,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `evidence_id` (`evidence_id`),
  CONSTRAINT `t_mobile_evidence_log_ibfk_1` FOREIGN KEY (`evidence_id`) REFERENCES `t_evidence` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_notifications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_notifications`;

CREATE TABLE `t_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_user_id` int(11) DEFAULT NULL,
  `data` text,
  `object_id` int(11) DEFAULT NULL,
  `object_id_type` varchar(45) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_notifications_t_users1` (`source_user_id`),
  CONSTRAINT `fk_t_notifications_t_users1` FOREIGN KEY (`source_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_offline_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_offline_tasks`;

CREATE TABLE `t_offline_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) DEFAULT NULL,
  `server_url` varchar(120) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `completed` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offline_ref_index` (`reference`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_ancestors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_ancestors`;

CREATE TABLE `t_organization_ancestors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_org_id` int(11) NOT NULL,
  `ancestor_org_id` int(11) NOT NULL,
  `distance` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_organizations_t_organization_ancestors_FK1` (`child_org_id`),
  KEY `t_organizations_t_organization_ancestors_FK2` (`ancestor_org_id`),
  CONSTRAINT `t_organizations_t_organization_ancestors_FK1` FOREIGN KEY (`child_org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_organizations_t_organization_ancestors_FK2` FOREIGN KEY (`ancestor_org_id`) REFERENCES `t_organizations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_import_added_elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_import_added_elements`;

CREATE TABLE `t_organization_import_added_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_import_file_id` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `line_number` int(11) DEFAULT NULL,
  `line_text` text,
  `importer_log` text,
  `table_affected` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `import_file_fk` (`organization_import_file_id`),
  CONSTRAINT `import_file_fk` FOREIGN KEY (`organization_import_file_id`) REFERENCES `t_organization_import_files` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_import_file_line_read_status
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_import_file_line_read_status`;

CREATE TABLE `t_organization_import_file_line_read_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_import_file_id` int(11) DEFAULT NULL,
  `line_number` int(11) DEFAULT NULL,
  `line_text` text,
  `is_succesfull` tinyint(4) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `importer_log` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `import_fk` (`organization_import_file_id`),
  CONSTRAINT `import_fk` FOREIGN KEY (`organization_import_file_id`) REFERENCES `t_organization_import_files` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_import_files
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_import_files`;

CREATE TABLE `t_organization_import_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `system_date` datetime DEFAULT NULL,
  `is_succesfull` tinyint(4) DEFAULT NULL,
  `completed` datetime DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `filename_x` (`filename`),
  KEY `org_fk` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_reference_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_reference_contents`;

CREATE TABLE `t_organization_reference_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `index` int(10) unsigned NOT NULL DEFAULT '0',
  `display_name` varchar(255) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id` (`org_id`,`content_id`),
  KEY `content_id` (`content_id`),
  CONSTRAINT `t_organization_reference_contents_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_organization_reference_contents_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organization_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organization_users`;

CREATE TABLE `t_organization_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_organization_users_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_organization_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organizations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organizations`;

CREATE TABLE `t_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `meta` text,
  `upload_directory_name` varchar(255) DEFAULT NULL,
  `time_zone` varchar(128) NOT NULL,
  `common_name` varchar(255) NOT NULL,
  `external_organization_id` varchar(255) DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `revenue_share` decimal(10,4) DEFAULT NULL,
  `is_test_org` tinyint(4) DEFAULT '0',
  `content_thumbnail_id` int(11) DEFAULT NULL,
  `school_year_start_month` int(4) DEFAULT '7',
  `school_year_start_day` int(4) DEFAULT '15',
  `reference_documents_title` varchar(255) DEFAULT NULL,
  `disallow_observations` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `disallow_goals` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `upload_dir_k` (`upload_directory_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_organizations_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_organizations_copy`;

CREATE TABLE `t_organizations_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_payment_accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_payment_accounts`;

CREATE TABLE `t_payment_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'STRIPE',
  `customer_id` varchar(250) DEFAULT NULL,
  `card` varchar(50) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `last4` varchar(4) DEFAULT NULL,
  `full_name` varchar(75) DEFAULT NULL,
  `address_line1` varchar(250) DEFAULT NULL,
  `address_line2` varchar(250) DEFAULT NULL,
  `address_city` varchar(250) DEFAULT NULL,
  `address_zip` varchar(250) DEFAULT NULL,
  `expiration` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_payment_accounts_t_users1` (`user_id`),
  CONSTRAINT `fk_t_payment_accounts_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_prepayment_accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_prepayment_accounts`;

CREATE TABLE `t_prepayment_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'PD_CREDITS',
  `name` varchar(255) NOT NULL DEFAULT 'PD Credits',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`),
  CONSTRAINT `t_prepayment_accounts_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_prepayment_deposits
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_prepayment_deposits`;

CREATE TABLE `t_prepayment_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prepayment_account_id` int(11) NOT NULL,
  `amount` decimal(11,2) unsigned NOT NULL DEFAULT '0.00',
  `description` text,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prepayment_account_id` (`prepayment_account_id`),
  CONSTRAINT `t_prepayment_deposits_ibfk_1` FOREIGN KEY (`prepayment_account_id`) REFERENCES `t_prepayment_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_privileges
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_privileges`;

CREATE TABLE `t_privileges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(80) NOT NULL,
  `description` char(80) NOT NULL,
  `role_type_const` char(40) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_proficiency_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_proficiency_levels`;

CREATE TABLE `t_proficiency_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_id` int(11) NOT NULL,
  `name` char(40) NOT NULL,
  `short_name` varchar(20) DEFAULT NULL,
  `index` int(11) NOT NULL,
  `is_positive` tinyint(1) NOT NULL DEFAULT '1',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_rubrics_t_proficiency_levels_FK1` (`rubric_id`),
  CONSTRAINT `t_proficiency_levels_t_rubric` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_proficiency_levels_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_proficiency_levels_copy`;

CREATE TABLE `t_proficiency_levels_copy` (
  `unique_rubric_id` varchar(100) NOT NULL DEFAULT '',
  `name` char(40) NOT NULL,
  `index` int(11) NOT NULL,
  KEY `t_rubrics_t_proficiency_levels_FK1` (`unique_rubric_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_purchase_request_responses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_purchase_request_responses`;

CREATE TABLE `t_purchase_request_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `note` text,
  `rejected` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_purchase_request_responses_t_purchase_requests1` (`purchase_request_id`),
  KEY `fk_t_purchase_request_responses_t_users1` (`user_id`),
  CONSTRAINT `fk_t_purchase_request_responses_t_purchase_requests1` FOREIGN KEY (`purchase_request_id`) REFERENCES `t_purchase_requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchase_request_responses_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_purchase_requests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_purchase_requests`;

CREATE TABLE `t_purchase_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `note` text,
  `approved_by_user_id` int(11) DEFAULT NULL,
  `approved` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_purchase_requests_t_users1` (`user_id`),
  KEY `fk_t_purchase_requests_t_resources1` (`resource_id`),
  KEY `fk_t_purchase_requests_t_users2` (`approved_by_user_id`),
  CONSTRAINT `fk_t_purchase_requests_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchase_requests_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchase_requests_t_users2` FOREIGN KEY (`approved_by_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_purchases
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_purchases`;

CREATE TABLE `t_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL COMMENT '	',
  `user_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `payment_account_id` int(11) DEFAULT NULL,
  `prepayment_account_id` int(11) DEFAULT NULL,
  `vendor_account_id` int(11) DEFAULT NULL,
  `purchase_request_id` int(11) DEFAULT NULL,
  `payment_processor_charge_id` varchar(250) DEFAULT NULL,
  `purchased` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_purchases_t_resources1` (`resource_id`),
  KEY `fk_t_purchases_t_payment_accounts1` (`payment_account_id`),
  KEY `fk_t_purchases_t_vendor_accounts1` (`vendor_account_id`),
  KEY `fk_t_purchases_t_purchase_requests1` (`purchase_request_id`),
  KEY `fk_t_purchases_t_users1` (`user_id`),
  KEY `prepayment_account_id` (`prepayment_account_id`),
  CONSTRAINT `fk_t_purchases_t_payment_accounts1` FOREIGN KEY (`payment_account_id`) REFERENCES `t_payment_accounts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchases_t_purchase_requests1` FOREIGN KEY (`purchase_request_id`) REFERENCES `t_purchase_requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchases_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchases_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_purchases_t_vendor_accounts1` FOREIGN KEY (`vendor_account_id`) REFERENCES `t_vendor_accounts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_purchases_ibfk_1` FOREIGN KEY (`prepayment_account_id`) REFERENCES `t_prepayment_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_attempts`;

CREATE TABLE `t_question_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_pool_attempt_id` int(11) NOT NULL,
  `question_template_id` int(11) NOT NULL,
  `score` double DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_question_attempts_t_question_pool_attempts1` (`question_pool_attempt_id`),
  KEY `fk_t_question_attempts_t_question_templates1` (`question_template_id`),
  CONSTRAINT `fk_t_question_attempts_t_question_pool_attempts1` FOREIGN KEY (`question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_question_attempts_t_question_templates1` FOREIGN KEY (`question_template_id`) REFERENCES `t_question_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_component_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_component_attempts`;

CREATE TABLE `t_question_component_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_attempt_id` int(11) NOT NULL,
  `question_component_template_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_question_component_attempts_t_question_attempts1` (`question_attempt_id`),
  KEY `fk_t_question_component_attempts_t_question_component_templat1` (`question_component_template_id`),
  CONSTRAINT `fk_t_question_component_attempts_t_question_attempts1` FOREIGN KEY (`question_attempt_id`) REFERENCES `t_question_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_question_component_attempts_t_question_component_templat1` FOREIGN KEY (`question_component_template_id`) REFERENCES `t_question_component_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_component_choice_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_component_choice_attempts`;

CREATE TABLE `t_question_component_choice_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_component_attempt_id` int(11) NOT NULL,
  `value` text,
  `question_component_choice_template_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `explanation` text,
  PRIMARY KEY (`id`),
  KEY `fk_t_question_component_choice_attempts_t_question_component_1` (`question_component_attempt_id`),
  KEY `fk_t_question_component_choice_attempts_t_question_component_2` (`question_component_choice_template_id`),
  CONSTRAINT `fk_t_question_component_choice_attempts_t_question_component_1` FOREIGN KEY (`question_component_attempt_id`) REFERENCES `t_question_component_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_question_component_choice_attempts_t_question_component_2` FOREIGN KEY (`question_component_choice_template_id`) REFERENCES `t_question_component_choice_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_component_choice_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_component_choice_templates`;

CREATE TABLE `t_question_component_choice_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_component_template_id` int(11) NOT NULL,
  `index` int(3) NOT NULL,
  `value` varchar(250) DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT '0',
  `date_deleted` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_question_component_choice_templates_t_question_component1` (`question_component_template_id`),
  CONSTRAINT `fk_t_question_component_choice_templates_t_question_component1` FOREIGN KEY (`question_component_template_id`) REFERENCES `t_question_component_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_component_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_component_templates`;

CREATE TABLE `t_question_component_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_template_id` int(11) NOT NULL,
  `index` int(3) NOT NULL,
  `question_component_type_id` int(11) DEFAULT NULL,
  `key` varchar(50) DEFAULT NULL,
  `value` text,
  `default_text` varchar(250) DEFAULT NULL,
  `default_answer` text,
  `date_deleted` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `description` text,
  `allow_explanation` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_t_question_component_templates_t_question_templates1` (`question_template_id`),
  KEY `fk_question_templates_question_types1` (`question_component_type_id`),
  CONSTRAINT `fk_t_question_component_templates_t_question_templates1` FOREIGN KEY (`question_template_id`) REFERENCES `t_question_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_pool_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_pool_attempts`;

CREATE TABLE `t_question_pool_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_pool_template_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `score_total` double DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `is_complete` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_t_question_pool_attempts_t_question_pool_templates1` (`question_pool_template_id`),
  CONSTRAINT `fk_t_question_pool_attempts_t_question_pool_templates1` FOREIGN KEY (`question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_pool_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_pool_templates`;

CREATE TABLE `t_question_pool_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `question_pool_type_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `date_deleted` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_question_template_pools_t_organizations1` (`org_id`),
  KEY `fk_question_pool_templates_question_pool_types1` (`question_pool_type_id`),
  CONSTRAINT `fk_question_pool_templates_question_pool_types1` FOREIGN KEY (`question_pool_type_id`) REFERENCES `t_question_pool_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_question_template_pools_t_organizations1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_pool_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_pool_types`;

CREATE TABLE `t_question_pool_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_templates`;

CREATE TABLE `t_question_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_pool_template_id` int(11) NOT NULL,
  `question_type_id` int(11) NOT NULL,
  `index` int(3) NOT NULL,
  `points_possible` int(5) DEFAULT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `date_deleted` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_question_templates_question_pool_templates1` (`question_pool_template_id`),
  KEY `fk_question_templates_question_types1` (`question_type_id`),
  CONSTRAINT `fk_question_templates_question_pool_templates1` FOREIGN KEY (`question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_question_templates_question_types1` FOREIGN KEY (`question_type_id`) REFERENCES `t_question_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_question_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_question_types`;

CREATE TABLE `t_question_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rating_indicators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rating_indicators`;

CREATE TABLE `t_rating_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `proficiency_level_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_rating_indicators_FK1` (`rating_id`),
  KEY `t_rating_indicators_FK2` (`rating_id`,`indicator_id`,`proficiency_level_id`),
  KEY `t_rating_indicators_FK3` (`indicator_id`,`proficiency_level_id`),
  KEY `t_rating_indicators_FK4` (`proficiency_level_id`),
  CONSTRAINT `t_rating_indicators_FK1` FOREIGN KEY (`rating_id`) REFERENCES `t_ratings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_rating_indicators_FK3` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicators` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_rating_indicators_FK4` FOREIGN KEY (`proficiency_level_id`) REFERENCES `t_proficiency_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rating_subitems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rating_subitems`;

CREATE TABLE `t_rating_subitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating_id` int(11) NOT NULL,
  `indicator_proficiency_level_subitem_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rating_id` (`rating_id`),
  KEY `indicator_proficiency_level_subitem_id` (`indicator_proficiency_level_subitem_id`),
  KEY `rating_subitem_key` (`rating_id`,`indicator_proficiency_level_subitem_id`),
  CONSTRAINT `t_rating_subitems_ibfk_1` FOREIGN KEY (`rating_id`) REFERENCES `t_ratings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_rating_subitems_ibfk_2` FOREIGN KEY (`indicator_proficiency_level_subitem_id`) REFERENCES `t_indicator_proficiency_level_subitems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_ratings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_ratings`;

CREATE TABLE `t_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_required_resources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_required_resources`;

CREATE TABLE `t_required_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL,
  `question_pool_template_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `u_question_pool_templates` (`question_pool_template_id`),
  CONSTRAINT `u_question_pool_templates` FOREIGN KEY (`question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_attempt_goals
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_attempt_goals`;

CREATE TABLE `t_resource_attempt_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_attempt_id` int(11) NOT NULL,
  `goal_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_attempt_goals_t_resource_attempt1` (`resource_attempt_id`),
  KEY `fk_t_resource_attempt_goals_t_goals1` (`goal_id`),
  CONSTRAINT `fk_t_resource_attempt_goals_t_goals1` FOREIGN KEY (`goal_id`) REFERENCES `t_goals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_goals_t_resource_attempt1` FOREIGN KEY (`resource_attempt_id`) REFERENCES `t_resource_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_attempt_indicator_feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_attempt_indicator_feedback`;

CREATE TABLE `t_resource_attempt_indicator_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_attempt_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `proficiency_level_id` int(11) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `indicator_id` (`indicator_id`),
  KEY `resource_attempt_id` (`resource_attempt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_attempts`;

CREATE TABLE `t_resource_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `active_tab` varchar(50) DEFAULT NULL COMMENT 'indicates the furthest tab for a user has accessed for this resource',
  `question_pool_attempt_id` int(11) DEFAULT NULL,
  `survey_question_pool_attempt_id` int(11) DEFAULT NULL,
  `due` datetime DEFAULT NULL,
  `started` datetime DEFAULT NULL,
  `completed` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_attempt_t_question_pool_attempts1` (`question_pool_attempt_id`),
  KEY `fk_t_resource_attempt_t_users1` (`user_id`),
  KEY `fk_t_resource_attempt_t_resources1` (`resource_id`),
  KEY `fk_t_question_pool_attempt2` (`survey_question_pool_attempt_id`),
  CONSTRAINT `fk_t_question_pool_attempt2` FOREIGN KEY (`survey_question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_t_question_pool_attempts1` FOREIGN KEY (`question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_content_attempt_evidence
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_content_attempt_evidence`;

CREATE TABLE `t_resource_content_attempt_evidence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_content_attempt_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1` (`resource_content_attempt_id`),
  KEY `FK2` (`content_id`),
  CONSTRAINT `FK1_CONST` FOREIGN KEY (`resource_content_attempt_id`) REFERENCES `t_resource_content_attempts` (`id`),
  CONSTRAINT `FK2_CONST` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_resource_content_attempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_content_attempts`;

CREATE TABLE `t_resource_content_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_content_id` int(11) NOT NULL COMMENT '  ',
  `resource_attempt_id` int(11) NOT NULL,
  `todo_question_pool_attempt_id` int(11) DEFAULT NULL,
  `activity_group_id` int(11) DEFAULT NULL,
  `started` datetime DEFAULT NULL,
  `completed` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_attempt_contents_t_resource_contents1_idx` (`resource_content_id`),
  KEY `fk_t_resource_attempt_contents_t_resource_attempts1_idx` (`resource_attempt_id`),
  KEY `fk_t_resource_attempt_contents_t_question_pool_attempts1_idx` (`todo_question_pool_attempt_id`),
  KEY `fk_t_resource_attempt_contents_t_activity_groups1_idx` (`activity_group_id`),
  CONSTRAINT `fk_t_resource_attempt_contents_t_activity_groups1` FOREIGN KEY (`activity_group_id`) REFERENCES `t_activity_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_contents_t_question_pool_attempts1` FOREIGN KEY (`todo_question_pool_attempt_id`) REFERENCES `t_question_pool_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_contents_t_resource_attempts1` FOREIGN KEY (`resource_attempt_id`) REFERENCES `t_resource_attempts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_attempt_contents_t_resource_contents1` FOREIGN KEY (`resource_content_id`) REFERENCES `t_resource_contents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_resource_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_contents`;

CREATE TABLE `t_resource_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `index` int(2) NOT NULL,
  `resource_type` varchar(15) NOT NULL,
  `sub_type` varchar(10) DEFAULT NULL,
  `allow_download` tinyint(1) NOT NULL DEFAULT '1',
  `todo_question_pool_template_id` int(11) DEFAULT NULL,
  `content_thumbnail_id` int(11) DEFAULT NULL,
  `activity_group_template_id` int(11) DEFAULT NULL,
  `title` text,
  `description` text COMMENT ' ',
  `author` varchar(75) DEFAULT NULL COMMENT '   ',
  `url` text,
  `reflection_hint` text,
  `meta` text,
  `deleted` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_contents_t_resources1_idx` (`resource_id`),
  KEY `fk_t_resource_contents_t_contents1_idx` (`content_id`),
  KEY `fk_t_resource_contents_t_question_pool_templates1_idx` (`todo_question_pool_template_id`),
  KEY `fk_t_resource_contents_t_content_thumbnails1_idx` (`content_thumbnail_id`),
  KEY `fk_t_resource_contents_t_activity_group_templates1_idx` (`activity_group_template_id`),
  CONSTRAINT `fk_t_resource_contents_t_activity_group_templates1` FOREIGN KEY (`activity_group_template_id`) REFERENCES `t_activity_group_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_contents_t_contents1` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_contents_t_content_thumbnails1` FOREIGN KEY (`content_thumbnail_id`) REFERENCES `t_content_thumbnails` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_contents_t_question_pool_templates1` FOREIGN KEY (`todo_question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_contents_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_resource_grade_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_grade_levels`;

CREATE TABLE `t_resource_grade_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `grade_level_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_subects_t_resources1` (`resource_id`),
  KEY `fk_t_resource_grade_levels_t_grade_levels1` (`grade_level_id`),
  CONSTRAINT `fk_t_resource_grade_levels_t_grade_levels1` FOREIGN KEY (`grade_level_id`) REFERENCES `t_grade_levels` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_subects_t_resources10` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_indicator_proficiency_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_indicator_proficiency_levels`;

CREATE TABLE `t_resource_indicator_proficiency_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `indicator_proficiency_level_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_indicator_proficiency_levels_t_resources1` (`resource_id`),
  KEY `fk_t_resource_indicator_proficiency_levels_t_indicator_profic1` (`indicator_proficiency_level_id`),
  CONSTRAINT `fk_t_resource_indicator_proficiency_levels_t_indicator_profic1` FOREIGN KEY (`indicator_proficiency_level_id`) REFERENCES `t_indicator_proficiency_levels` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_indicator_proficiency_levels_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_recommendations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_recommendations`;

CREATE TABLE `t_resource_recommendations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_user_id` int(11) NOT NULL,
  `target_user_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `activity_feedback_id` int(11) DEFAULT NULL,
  `message` text,
  `accepted` timestamp NULL DEFAULT NULL,
  `dismissed` timestamp NULL DEFAULT NULL,
  `deleted` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `target_user_id` (`target_user_id`),
  KEY `fk_t_resource_recommendations_t_resources1` (`resource_id`),
  KEY `fk_t_resource_recommendations_t_users1` (`source_user_id`),
  KEY `activity_feedback_id` (`activity_feedback_id`),
  CONSTRAINT `activity_feedback_id` FOREIGN KEY (`activity_feedback_id`) REFERENCES `t_activity_feedback` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_recommendations_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_recommendations_t_users1` FOREIGN KEY (`source_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_recommendations_t_users2` FOREIGN KEY (`target_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_resource_stats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_stats`;

CREATE TABLE `t_resource_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `count_recommend` int(11) DEFAULT NULL,
  `percent_recommend` int(11) DEFAULT NULL,
  `count_concrete_strategies` int(11) DEFAULT NULL,
  `percent_concrete_strategies` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_resource_subjects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_subjects`;

CREATE TABLE `t_resource_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `subject_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_subects_t_resources1` (`resource_id`),
  KEY `fk_t_resource_subects_t_subjects1` (`subject_id`),
  CONSTRAINT `fk_t_resource_subects_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_subects_t_subjects1` FOREIGN KEY (`subject_id`) REFERENCES `t_subjects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resource_template_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_template_contents`;

CREATE TABLE `t_resource_template_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `required_resource_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_fk` (`content_id`),
  KEY `required_resource_fk` (`required_resource_id`),
  CONSTRAINT `content_fk` FOREIGN KEY (`content_id`) REFERENCES `t_contents` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `required_resource_fk` FOREIGN KEY (`required_resource_id`) REFERENCES `t_required_resources` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='an observation template set can have predefined documents/fo';



# Dump of table t_resource_use_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resource_use_access`;

CREATE TABLE `t_resource_use_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '	',
  `resource_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `expiration` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resource_use_access_t_resources1` (`resource_id`),
  KEY `fk_t_resource_use_access_t_users1` (`user_id`),
  KEY `fk_t_resource_use_access_t_organizations1` (`org_id`),
  KEY `fk_t_resource_use_access_t_purchases1` (`purchase_id`),
  CONSTRAINT `fk_t_resource_use_access_t_organizations1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_use_access_t_purchases1` FOREIGN KEY (`purchase_id`) REFERENCES `t_purchases` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_use_access_t_resources1` FOREIGN KEY (`resource_id`) REFERENCES `t_resources` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resource_use_access_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_resources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_resources`;

CREATE TABLE `t_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `question_pool_template_id` int(11) DEFAULT NULL,
  `survey_question_pool_template_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `title` text,
  `description` text,
  `published` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `is_public` tinyint(1) DEFAULT '0' COMMENT '0 - Visible for all BloomBoard users, 1 - visible only for users associated to organization',
  `time_commitment` varchar(63) DEFAULT NULL,
  `default_resource_content_id` int(11) DEFAULT NULL,
  `bundle_import_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_resources_t_organizations1` (`org_id`),
  KEY `fk_t_resources_t_users1` (`creator_user_id`),
  KEY `fk_t_resources_t_question_pool_templates1` (`question_pool_template_id`),
  KEY `fk_t_resources_t_question_pool_templates2` (`survey_question_pool_template_id`),
  CONSTRAINT `fk_t_resources_t_organizations1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resources_t_question_pool_templates1` FOREIGN KEY (`question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resources_t_question_pool_templates2` FOREIGN KEY (`survey_question_pool_template_id`) REFERENCES `t_question_pool_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_resources_t_users1` FOREIGN KEY (`creator_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table t_role_privileges
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_role_privileges`;

CREATE TABLE `t_role_privileges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `privilege_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_roles_t_role_privileges_FK1` (`role_id`),
  KEY `t_privileges_t_role_privileges_FK1` (`privilege_id`),
  CONSTRAINT `t_privileges_t_role_privileges_FK1` FOREIGN KEY (`privilege_id`) REFERENCES `t_privileges` (`id`),
  CONSTRAINT `t_roles_t_role_privileges_FK1` FOREIGN KEY (`role_id`) REFERENCES `t_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_roles`;

CREATE TABLE `t_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL,
  `description` char(255) DEFAULT NULL,
  `role_type_const` char(40) NOT NULL,
  `role_is_const` char(40) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `rubric_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_type_const` (`role_type_const`,`role_is_const`),
  KEY `org_id` (`org_id`),
  KEY `rubric_id` (`rubric_id`),
  CONSTRAINT `t_roles_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_roles_ibfk_2` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rubric_organizations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rubric_organizations`;

CREATE TABLE `t_rubric_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `rubric_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ro_to_rubric_idx` (`rubric_id`),
  KEY `ro_to_org_idx` (`organization_id`),
  CONSTRAINT `ro_to_org` FOREIGN KEY (`organization_id`) REFERENCES `t_organizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ro_to_rubric` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rubric_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rubric_users`;

CREATE TABLE `t_rubric_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `rubric_id` int(11) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_rubric_users_to_users` (`user_id`,`rubric_id`),
  KEY `t_rubric_users_to_rubrics` (`rubric_id`),
  CONSTRAINT `t_rubric_users_to_rubrics` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`),
  CONSTRAINT `t_rubric_users_to_users` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rubrics
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rubrics`;

CREATE TABLE `t_rubrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) NOT NULL,
  `name` char(80) DEFAULT NULL,
  `unique_rubric_id` varchar(30) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `num_indicator_depth_level` int(11) NOT NULL,
  `num_proficiency_level` int(11) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `is_master` tinyint(4) NOT NULL,
  `allow_selection` tinyint(1) NOT NULL DEFAULT '1',
  `auto_selection` tinyint(1) NOT NULL DEFAULT '1',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rubric_to_organizations_KEY` (`organization_id`),
  KEY `is_active` (`is_active`),
  KEY `is_master` (`is_master`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_rubrics_copy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_rubrics_copy`;

CREATE TABLE `t_rubrics_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) NOT NULL,
  `name` char(80) DEFAULT NULL,
  `unique_rubric_id` varchar(50) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `num_indicator_depth_level` int(11) NOT NULL,
  `num_proficiency_level` int(11) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `is_master` tinyint(4) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_school_years
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_school_years`;

CREATE TABLE `t_school_years` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `start_year` int(11) NOT NULL,
  `end_year` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `index` int(4) NOT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_assessment_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_assessment_attributes`;

CREATE TABLE `t_slo_assessment_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slo_template_id` int(11) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `index` int(4) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_assessment_comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_assessment_comments`;

CREATE TABLE `t_slo_assessment_comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slo_assessment_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_assessment_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_assessment_contents`;

CREATE TABLE `t_slo_assessment_contents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slo_assessment_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_assessment_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_assessment_types`;

CREATE TABLE `t_slo_assessment_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slo_template_id` int(11) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `index` int(4) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_assessments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_assessments`;

CREATE TABLE `t_slo_assessments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `slo_id` int(11) NOT NULL,
  `question_pool_attempt_id` int(11) NOT NULL,
  `slo_assessment_type_id` int(11) DEFAULT NULL,
  `slo_assessment_attribute_id` int(11) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `rating_question_component_template_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slo_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slo_templates`;

CREATE TABLE `t_slo_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL,
  `org_id` int(11) NOT NULL,
  `question_pool_template_id` int(11) NOT NULL,
  `tpl_type` varchar(60) DEFAULT NULL,
  `instructions_url` varchar(220) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_slos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_slos`;

CREATE TABLE `t_slos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `slo_template_id` int(11) NOT NULL,
  `is_locked` tinyint(4) DEFAULT '0',
  `approval_requested` timestamp NULL DEFAULT NULL,
  `approver_id` int(11) DEFAULT NULL,
  `approved` timestamp NULL DEFAULT NULL,
  `completed` timestamp NULL DEFAULT NULL,
  `deleted` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_snapshots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_snapshots`;

CREATE TABLE `t_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating_id` int(11) NOT NULL,
  `subject_user_id` int(11) NOT NULL,
  `owner_user_id` int(11) NOT NULL,
  `rubric_id` int(11) NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  `filters` text,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_snapshots_FK1` (`rating_id`),
  KEY `t_snapshots_FK2` (`subject_user_id`),
  KEY `t_snapshots_FK3` (`owner_user_id`),
  KEY `t_snapshots_FK4` (`rubric_id`),
  CONSTRAINT `t_snapshots_FK1` FOREIGN KEY (`rating_id`) REFERENCES `t_ratings` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_snapshots_FK2` FOREIGN KEY (`subject_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_snapshots_FK3` FOREIGN KEY (`owner_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_snapshots_FK4` FOREIGN KEY (`rubric_id`) REFERENCES `t_rubrics` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_step_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_step_types`;

CREATE TABLE `t_step_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(80) NOT NULL,
  `is_task` tinyint(4) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `dependency_index` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_subjects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_subjects`;

CREATE TABLE `t_subjects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `code` varchar(10) NOT NULL DEFAULT '',
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_system_label_organizations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_system_label_organizations`;

CREATE TABLE `t_system_label_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `system_label_id` int(11) NOT NULL,
  `value` char(40) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_system_labels_t_system_label_organizations_FK1` (`system_label_id`),
  KEY `t_organizations_t_system_label_organizations_FK1` (`org_id`),
  CONSTRAINT `t_organizations_t_system_label_organizations_FK1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_system_labels_t_system_label_organizations_FK1` FOREIGN KEY (`system_label_id`) REFERENCES `t_system_labels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_system_labels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_system_labels`;

CREATE TABLE `t_system_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL,
  `description` char(80) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_tableau_dashboards
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_tableau_dashboards`;

CREATE TABLE `t_tableau_dashboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT '2001',
  `target_view` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `t_tableau_dashboards_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `t_organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `t_tableau_dashboards_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `t_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_tableau_user_snapshot
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_tableau_user_snapshot`;

CREATE TABLE `t_tableau_user_snapshot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_tableau_user_snapshot_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_attributes`;

CREATE TABLE `t_user_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `att_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_users_t_user_attributes_FK1` (`user_id`),
  KEY `t_attributes_t_user_attributes_FK1` (`att_id`),
  CONSTRAINT `t_attributes_t_user_attributes_FK1` FOREIGN KEY (`att_id`) REFERENCES `t_attributes` (`id`),
  CONSTRAINT `t_users_t_user_attributes_FK1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_grade_levels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_grade_levels`;

CREATE TABLE `t_user_grade_levels` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `grade_level_id` int(11) unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_users_t_user_grade_levels_FK1` (`user_id`),
  KEY `t_grade_levels_t_user_grade_levels_FK1` (`grade_level_id`),
  CONSTRAINT `t_grade_levels_t_user_grade_levels_FK1` FOREIGN KEY (`grade_level_id`) REFERENCES `t_grade_levels` (`id`),
  CONSTRAINT `t_users_t_user_grade_levels_FK1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_indicator_last_ratings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_indicator_last_ratings`;

CREATE TABLE `t_user_indicator_last_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `proficiency_level_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_indicator_proficiency_levels_t_user_indicator_last_ratings_FK1` (`indicator_id`),
  CONSTRAINT `t_indicator_proficiency_levels_t_user_indicator_last_ratings_FK1` FOREIGN KEY (`indicator_id`) REFERENCES `t_indicator_proficiency_levels` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_notifications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_notifications`;

CREATE TABLE `t_user_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `is_seen` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_t_user_notifications_t_notifications1` (`notification_id`),
  KEY `fk_t_user_notifications_t_users1` (`user_id`),
  CONSTRAINT `fk_t_user_notifications_t_notifications1` FOREIGN KEY (`notification_id`) REFERENCES `t_notifications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_t_user_notifications_t_users1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_roles`;

CREATE TABLE `t_user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `tableau_access` tinyint(1) NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_users_t_user_roles_FK1` (`user_id`),
  KEY `t_organizations_t_user_roles_FK1` (`org_id`),
  KEY `t_roles_t_user_roles_FK1` (`role_id`),
  KEY `role_id` (`role_id`,`org_id`,`user_id`),
  CONSTRAINT `t_organizations_t_user_roles_FK1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_roles_t_user_roles_FK1` FOREIGN KEY (`role_id`) REFERENCES `t_roles` (`id`),
  CONSTRAINT `t_users_t_user_roles_FK1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_subjects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_subjects`;

CREATE TABLE `t_user_subjects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subject_id` int(11) unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_users_t_user_subjects_FK1` (`user_id`),
  KEY `t_subjects_t_user_subjects_FK1` (`subject_id`),
  CONSTRAINT `t_subjects_t_user_subjects_FK1` FOREIGN KEY (`subject_id`) REFERENCES `t_subjects` (`id`),
  CONSTRAINT `t_users_t_user_subjects_FK1` FOREIGN KEY (`user_id`) REFERENCES `t_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_user_trending_ratings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_user_trending_ratings`;

CREATE TABLE `t_user_trending_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating_id` int(11) NOT NULL,
  `subject_user_id` int(11) NOT NULL,
  `rating_user_id` int(11) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_user_trending_ratings_FK1` (`rating_id`),
  KEY `t_user_trending_ratings_FK2` (`subject_user_id`),
  KEY `t_user_trending_ratings_FK3` (`rating_user_id`),
  CONSTRAINT `t_user_trending_ratings_FK1` FOREIGN KEY (`rating_id`) REFERENCES `t_ratings` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_user_trending_ratings_FK2` FOREIGN KEY (`subject_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `t_user_trending_ratings_FK3` FOREIGN KEY (`rating_user_id`) REFERENCES `t_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_users`;

CREATE TABLE `t_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` char(255) NOT NULL,
  `email` char(255) NOT NULL,
  `password` char(80) NOT NULL,
  `track_me_not` tinyint(1) DEFAULT NULL,
  `first_name` char(50) DEFAULT NULL,
  `last_name` char(50) DEFAULT NULL,
  `picture_url` char(255) DEFAULT NULL,
  `primary_org_id` int(11) NOT NULL,
  `default_role_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `is_active` tinyint(4) NOT NULL,
  `birthday` date DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `picture_bucket` int(11) NOT NULL DEFAULT '0',
  `time_zone` varchar(200) NOT NULL DEFAULT 'America/Los_Angeles',
  `login_count` int(11) NOT NULL DEFAULT '0',
  `first_login` datetime DEFAULT NULL,
  `last_login_timestamp` datetime DEFAULT NULL,
  `employee_id` varchar(99) DEFAULT NULL,
  `goal_planning_question_pool_attempt_id` int(11) DEFAULT NULL,
  `is_processed` tinyint(4) DEFAULT NULL,
  `password_set_timestamp` timestamp NULL DEFAULT NULL,
  `tos_signed_timestamp` timestamp NULL DEFAULT NULL,
  `is_test_account` tinyint(1) NOT NULL DEFAULT '0',
  `tableau_access` tinyint(1) NOT NULL DEFAULT '0',
  `json_flags` text,
  `json_profile` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_username` (`username`),
  UNIQUE KEY `unique_user_enforcer` (`employee_id`,`primary_org_id`),
  KEY `t_organizations_t_users_FK1` (`primary_org_id`),
  KEY `t_users_t_users_FK1` (`created_by`),
  KEY `is_processed_index` (`is_processed`),
  KEY `t_users_employee_id_idxx` (`primary_org_id`,`employee_id`),
  KEY `org_id` (`primary_org_id`),
  KEY `u_roles` (`default_role_id`),
  CONSTRAINT `t_organizations_t_users_FK1` FOREIGN KEY (`primary_org_id`) REFERENCES `t_organizations` (`id`),
  CONSTRAINT `t_users_t_users_FK1` FOREIGN KEY (`created_by`) REFERENCES `t_users` (`id`),
  CONSTRAINT `u_roles` FOREIGN KEY (`default_role_id`) REFERENCES `t_roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_vendor_accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_vendor_accounts`;

CREATE TABLE `t_vendor_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'STRIPE',
  `publishable_key` varchar(250) DEFAULT NULL,
  `access_token` varchar(250) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_t_vendor_accounts_t_organizations1` (`org_id`),
  CONSTRAINT `fk_t_vendor_accounts_t_organizations1` FOREIGN KEY (`org_id`) REFERENCES `t_organizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_workflow_step_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_workflow_step_roles`;

CREATE TABLE `t_workflow_step_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_step_id` int(11) NOT NULL,
  `access_role_id` int(11) NOT NULL,
  `access_level` char(10) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_workflow_steps_t_workflow_step_roles_FK1` (`workflow_step_id`),
  CONSTRAINT `t_workflow_steps_t_workflow_step_roles_FK1` FOREIGN KEY (`workflow_step_id`) REFERENCES `t_workflow_steps` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table t_workflow_steps
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_workflow_steps`;

CREATE TABLE `t_workflow_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_template_id` int(11) DEFAULT NULL,
  `step_type_id` int(11) NOT NULL,
  `name` char(120) NOT NULL,
  `index` int(11) NOT NULL,
  `is_event` tinyint(1) NOT NULL DEFAULT '0',
  `allow_due_date` tinyint(1) NOT NULL DEFAULT '0',
  `display_text` char(255) DEFAULT NULL,
  `is_multiple_role_action_required` tinyint(4) NOT NULL,
  `date_offset` int(11) DEFAULT NULL,
  `required_resource_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `enable_share_prompt` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `t_step_types_t_workflow_steps_FK1` (`step_type_id`),
  KEY `t_activity_templates_t_workflow_steps_FK1` (`activity_template_id`),
  KEY `t___required_resource_s_t_workflow_steps_FK1` (`required_resource_id`),
  CONSTRAINT `t_activity_templates_t_workflow_steps_FK1` FOREIGN KEY (`activity_template_id`) REFERENCES `t_activity_templates` (`id`),
  CONSTRAINT `t_step_types_t_workflow_steps_FK1` FOREIGN KEY (`step_type_id`) REFERENCES `t_step_types` (`id`),
  CONSTRAINT `t___required_resource_s_t_workflow_steps_FK1` FOREIGN KEY (`required_resource_id`) REFERENCES `t_required_resources` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

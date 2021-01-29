/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 80011
Source Host           : localhost:3306
Source Database       : binhai

Target Server Type    : MYSQL
Target Server Version : 80011
File Encoding         : 65001

Date: 2021-01-29 11:32:52
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dt_class
-- ----------------------------
DROP TABLE IF EXISTS `dt_class`;
CREATE TABLE `dt_class` (
  `cls_id` int(11) NOT NULL AUTO_INCREMENT,
  `cls_name` varchar(20) NOT NULL,
  `cls_dic_id_major` int(11) NOT NULL,
  `cls_clsr_id` int(11) DEFAULT NULL,
  `cls_stf_id_teacher` int(11) NOT NULL,
  `cls_stf_id_admin` int(11) NOT NULL,
  `cls_stf_id_job` int(11) NOT NULL,
  `cls_begin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `cls_end` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `cls_remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cls_id`),
  KEY `fk_teacher` (`cls_stf_id_teacher`),
  KEY `fk_admin` (`cls_stf_id_admin`),
  KEY `fk_job` (`cls_stf_id_job`),
  KEY `fk_clsr` (`cls_clsr_id`),
  KEY `fk_major` (`cls_dic_id_major`),
  CONSTRAINT `fk_admin` FOREIGN KEY (`cls_stf_id_admin`) REFERENCES `dt_staff` (`stf_id`),
  CONSTRAINT `fk_clsr` FOREIGN KEY (`cls_clsr_id`) REFERENCES `dt_classroom` (`clsr_id`),
  CONSTRAINT `fk_job` FOREIGN KEY (`cls_stf_id_job`) REFERENCES `dt_staff` (`stf_id`),
  CONSTRAINT `fk_major` FOREIGN KEY (`cls_dic_id_major`) REFERENCES `dt_dictionary` (`dic_id`),
  CONSTRAINT `fk_teacher` FOREIGN KEY (`cls_stf_id_teacher`) REFERENCES `dt_staff` (`stf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_class
-- ----------------------------
INSERT INTO `dt_class` VALUES ('8', '191202H5', '8', '30', '1', '5', '6', '2020', '2020', '123');
INSERT INTO `dt_class` VALUES ('9', '190701H5', '9', '32', '4', '5', '6', '2020', '2020', '262365');
INSERT INTO `dt_class` VALUES ('10', '190702H5', '9', '33', '1', '5', '6', '2020-05-04', '2020-05-07', '1656');
INSERT INTO `dt_class` VALUES ('11', '1905JAVA', '8', '34', '2', '5', '6', '2020-05-04', '2020-05-07', '36+3');
INSERT INTO `dt_class` VALUES ('12', '1903JAVA', '10', '42', '8', '5', '6', '2020-05-06', '2020-05-07', null);
INSERT INTO `dt_class` VALUES ('13', '1905UI', '10', '32', '10', '5', '6', '2020', null, '');
INSERT INTO `dt_class` VALUES ('29', '2010UI', '10', '32', '1', '5', '6', '2021-01-04', '2021-01-04', null);
INSERT INTO `dt_class` VALUES ('30', '2009H5', '10', null, '1', '5', '6', null, null, null);
INSERT INTO `dt_class` VALUES ('31', '2010H5', '9', null, '1', '5', '6', null, null, '789456');

-- ----------------------------
-- Table structure for dt_classroom
-- ----------------------------
DROP TABLE IF EXISTS `dt_classroom`;
CREATE TABLE `dt_classroom` (
  `clsr_id` int(11) NOT NULL AUTO_INCREMENT,
  `clsr_name` varchar(20) NOT NULL,
  `clsr_occupy` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`clsr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_classroom
-- ----------------------------
INSERT INTO `dt_classroom` VALUES ('30', '401教室', '1');
INSERT INTO `dt_classroom` VALUES ('32', '403教室', '0');
INSERT INTO `dt_classroom` VALUES ('33', '404教室', '1');
INSERT INTO `dt_classroom` VALUES ('34', '405教室', '1');
INSERT INTO `dt_classroom` VALUES ('42', '406教室', '0');
INSERT INTO `dt_classroom` VALUES ('51', '407教室', '0');

-- ----------------------------
-- Table structure for dt_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `dt_dictionary`;
CREATE TABLE `dt_dictionary` (
  `dic_id` int(11) NOT NULL AUTO_INCREMENT,
  `dic_name` varchar(20) NOT NULL,
  `dic_group_key` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dic_group_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_dictionary
-- ----------------------------
INSERT INTO `dt_dictionary` VALUES ('1', '本科及以上', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('2', '专科', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('3', '高中及以下', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('4', '教学老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('5', '教务老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('6', '就业老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('7', '市场老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('8', 'Java', 'class_major', '班级专业');
INSERT INTO `dt_dictionary` VALUES ('9', 'H5', 'class_major', '班级专业');
INSERT INTO `dt_dictionary` VALUES ('10', 'UI设计', 'class_major', '班级专业');

-- ----------------------------
-- Table structure for dt_function
-- ----------------------------
DROP TABLE IF EXISTS `dt_function`;
CREATE TABLE `dt_function` (
  `func_id` int(11) NOT NULL AUTO_INCREMENT,
  `func_name` varchar(50) NOT NULL,
  `func_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `func_fid` int(11) NOT NULL,
  PRIMARY KEY (`func_id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_function
-- ----------------------------
INSERT INTO `dt_function` VALUES ('44', '系统管理', '', '0');
INSERT INTO `dt_function` VALUES ('45', '系统功能管理', 'Func', '44');
INSERT INTO `dt_function` VALUES ('101', '角色及角色功能管理', 'Roles', '44');
INSERT INTO `dt_function` VALUES ('102', '教学管理', '', '0');
INSERT INTO `dt_function` VALUES ('109', '教室管理', 'Classroom', '102');
INSERT INTO `dt_function` VALUES ('110', '用户及角色管理', 'User', '44');
INSERT INTO `dt_function` VALUES ('114', '行政人事管理', '', '0');
INSERT INTO `dt_function` VALUES ('115', '员工管理', 'Staff', '114');
INSERT INTO `dt_function` VALUES ('116', '班级管理', 'Class', '102');
INSERT INTO `dt_function` VALUES ('117', '学生管理', 'Student', '102');
INSERT INTO `dt_function` VALUES ('118', '修改密码', 'ChangePwd', '0');
INSERT INTO `dt_function` VALUES ('119', '考勤管理', 'Attendance', '114');

-- ----------------------------
-- Table structure for dt_role
-- ----------------------------
DROP TABLE IF EXISTS `dt_role`;
CREATE TABLE `dt_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_role
-- ----------------------------
INSERT INTO `dt_role` VALUES ('28', '学生');
INSERT INTO `dt_role` VALUES ('20', '学生1');
INSERT INTO `dt_role` VALUES ('16', '教务老师');
INSERT INTO `dt_role` VALUES ('15', '教学老师');
INSERT INTO `dt_role` VALUES ('18', '生活老师');
INSERT INTO `dt_role` VALUES ('26', '老师');
INSERT INTO `dt_role` VALUES ('29', '老师8');

-- ----------------------------
-- Table structure for dt_role_function
-- ----------------------------
DROP TABLE IF EXISTS `dt_role_function`;
CREATE TABLE `dt_role_function` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `func_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_func_id` (`func_id`),
  KEY `fk_role_id` (`role_id`),
  CONSTRAINT `fk_func_id` FOREIGN KEY (`func_id`) REFERENCES `dt_function` (`func_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `dt_role` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_role_function
-- ----------------------------
INSERT INTO `dt_role_function` VALUES ('45', '16', '102');
INSERT INTO `dt_role_function` VALUES ('46', '16', '109');
INSERT INTO `dt_role_function` VALUES ('49', '26', '102');
INSERT INTO `dt_role_function` VALUES ('50', '26', '109');
INSERT INTO `dt_role_function` VALUES ('51', '26', '116');
INSERT INTO `dt_role_function` VALUES ('52', '26', '117');
INSERT INTO `dt_role_function` VALUES ('58', '20', '102');
INSERT INTO `dt_role_function` VALUES ('59', '20', '117');
INSERT INTO `dt_role_function` VALUES ('60', '20', '118');
INSERT INTO `dt_role_function` VALUES ('72', '15', '102');
INSERT INTO `dt_role_function` VALUES ('73', '15', '109');
INSERT INTO `dt_role_function` VALUES ('74', '15', '116');
INSERT INTO `dt_role_function` VALUES ('75', '15', '117');
INSERT INTO `dt_role_function` VALUES ('76', '15', '118');
INSERT INTO `dt_role_function` VALUES ('77', '28', '102');
INSERT INTO `dt_role_function` VALUES ('78', '28', '116');
INSERT INTO `dt_role_function` VALUES ('79', '28', '117');

-- ----------------------------
-- Table structure for dt_staff
-- ----------------------------
DROP TABLE IF EXISTS `dt_staff`;
CREATE TABLE `dt_staff` (
  `stf_id` int(11) NOT NULL AUTO_INCREMENT,
  `stf_name` varchar(20) NOT NULL,
  `stf_category` int(11) NOT NULL,
  `stf_remark` varchar(255) DEFAULT NULL,
  `stf_invalid` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`stf_id`),
  KEY `fk_category` (`stf_category`),
  CONSTRAINT `fk_category` FOREIGN KEY (`stf_category`) REFERENCES `dt_dictionary` (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_staff
-- ----------------------------
INSERT INTO `dt_staff` VALUES ('1', '李文奇', '4', 'adbfefvr', '1');
INSERT INTO `dt_staff` VALUES ('2', '杜鲜', '4', null, '1');
INSERT INTO `dt_staff` VALUES ('3', '高成全', '4', '的非法人人', '0');
INSERT INTO `dt_staff` VALUES ('4', '鞠祥明', '4', 'fregfrht', '1');
INSERT INTO `dt_staff` VALUES ('5', '邱丽娜', '5', null, '1');
INSERT INTO `dt_staff` VALUES ('6', '王丽', '6', null, '1');
INSERT INTO `dt_staff` VALUES ('7', '臧金玉', '4', 'fregregtr', '1');
INSERT INTO `dt_staff` VALUES ('8', '郑延波', '4', 'srgrefg', '1');
INSERT INTO `dt_staff` VALUES ('9', '唐慎之', '4', 'fregf', '0');
INSERT INTO `dt_staff` VALUES ('10', '张三丰', '4', '人员合同', '0');
INSERT INTO `dt_staff` VALUES ('15', '王五', '4', '123', '1');
INSERT INTO `dt_staff` VALUES ('17', '王五', '4', '', '1');

-- ----------------------------
-- Table structure for dt_student
-- ----------------------------
DROP TABLE IF EXISTS `dt_student`;
CREATE TABLE `dt_student` (
  `stu_id` int(11) NOT NULL AUTO_INCREMENT,
  `stu_name` varchar(20) NOT NULL,
  `stu_avatar` varchar(255) DEFAULT NULL,
  `stu_cls_id` int(11) DEFAULT NULL,
  `stu_sex` int(1) NOT NULL,
  `stu_phone` varchar(11) NOT NULL,
  `stu_phone2` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `stu_born` varchar(10) NOT NULL,
  `stu_qualification` int(11) NOT NULL,
  `stu_school` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `stu_major` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `stu_address` varchar(100) NOT NULL,
  `stu_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`stu_id`),
  KEY `fk_qualification` (`stu_qualification`),
  KEY `fk_cls_id` (`stu_cls_id`),
  CONSTRAINT `fk_cls_id` FOREIGN KEY (`stu_cls_id`) REFERENCES `dt_class` (`cls_id`),
  CONSTRAINT `fk_qualification` FOREIGN KEY (`stu_qualification`) REFERENCES `dt_dictionary` (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_student
-- ----------------------------
INSERT INTO `dt_student` VALUES ('1', '张三', '/images/student/1609915268078.jpg', '30', '1', '13812344321', '13514788741', '1998-12-12', '1', '青岛滨海学院', '计算机信息管理', '山东省青岛市李沧区发发发小区', '123456');
INSERT INTO `dt_student` VALUES ('2', '李四', null, '13', '0', '14725899852', '15612345623', '1997-05-19', '2', '青岛滨海学院', '计算机网络技术', '山东省青岛市城阳区121号', '654321');
INSERT INTO `dt_student` VALUES ('3', '王五', null, '13', '1', '15212344321', '17814788741', '1998-08-28', '2', '青岛滨海学院', '商务英语', '山东省济南市历下区', '');
INSERT INTO `dt_student` VALUES ('4', '李一', null, null, '0', '18956233256', '18945616541', '2000-10-08', '1', '青岛滨海学院', '会计', '山东省青岛市崂山区', '');
INSERT INTO `dt_student` VALUES ('5', '周二', null, null, '0', '14565452254', '18956411456', '1999-04-14', '2', '青岛滨海学院', '计算机应用技术', '山东省青岛市黄岛区', '');
INSERT INTO `dt_student` VALUES ('6', '周三', null, '30', '1', '17896322369', '13278944987', '1996-05-20', '1', '青岛滨海学院', '通信工程', '山东省青岛市市南区', '');
INSERT INTO `dt_student` VALUES ('13', '周五', null, null, '1', '14777777777', '12345678', '2021-01-13', '2', '青岛滨海学院', '计算机网络技术', '山东省青岛市市南区', '');

-- ----------------------------
-- Table structure for dt_user
-- ----------------------------
DROP TABLE IF EXISTS `dt_user`;
CREATE TABLE `dt_user` (
  `user_name` varchar(20) NOT NULL,
  `user_pwd` varchar(20) NOT NULL,
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_user
-- ----------------------------
INSERT INTO `dt_user` VALUES ('12333333333', '123');
INSERT INTO `dt_user` VALUES ('13812344321', '123');
INSERT INTO `dt_user` VALUES ('14565452254', '123');
INSERT INTO `dt_user` VALUES ('14725899852', '123');
INSERT INTO `dt_user` VALUES ('14777777777', '123');
INSERT INTO `dt_user` VALUES ('15212344321', '123');
INSERT INTO `dt_user` VALUES ('17896322369', '123');
INSERT INTO `dt_user` VALUES ('18956233256', '123');
INSERT INTO `dt_user` VALUES ('aa1', '154');
INSERT INTO `dt_user` VALUES ('user1', '1234');
INSERT INTO `dt_user` VALUES ('user10', '1149');
INSERT INTO `dt_user` VALUES ('user11', '147');
INSERT INTO `dt_user` VALUES ('user12', '145');
INSERT INTO `dt_user` VALUES ('user13', '110');
INSERT INTO `dt_user` VALUES ('user14', '111');
INSERT INTO `dt_user` VALUES ('user15', '112');
INSERT INTO `dt_user` VALUES ('user2', '456');
INSERT INTO `dt_user` VALUES ('user3', '789');
INSERT INTO `dt_user` VALUES ('user4', '101');
INSERT INTO `dt_user` VALUES ('user5', '102');
INSERT INTO `dt_user` VALUES ('user6', '103');
INSERT INTO `dt_user` VALUES ('user7', '104');
INSERT INTO `dt_user` VALUES ('user8', '105');
INSERT INTO `dt_user` VALUES ('user9', '106');

-- ----------------------------
-- Table structure for dt_user_role
-- ----------------------------
DROP TABLE IF EXISTS `dt_user_role`;
CREATE TABLE `dt_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_role_id2` (`role_id`),
  KEY `fk_user_name` (`user_name`),
  CONSTRAINT `fk_role_id2` FOREIGN KEY (`role_id`) REFERENCES `dt_role` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_name` FOREIGN KEY (`user_name`) REFERENCES `dt_user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_user_role
-- ----------------------------
INSERT INTO `dt_user_role` VALUES ('20', 'user10', '16');
INSERT INTO `dt_user_role` VALUES ('22', 'user11', '20');
INSERT INTO `dt_user_role` VALUES ('23', 'user12', '16');
INSERT INTO `dt_user_role` VALUES ('25', 'user13', '20');
INSERT INTO `dt_user_role` VALUES ('30', 'aa1', '20');
INSERT INTO `dt_user_role` VALUES ('32', 'user1', '15');

-- ----------------------------
-- Procedure structure for p_changePwd
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_changePwd`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_changePwd`(
	_user_name varchar(20),
	oldPwd varchar(20),
	newPwd varchar(20)
)
BEGIN
	DECLARE result varchar(20) DEFAULT '原始密码错误';
	DECLARE temp int;
	
	SELECT count(*) INTO temp FROM dt_user WHERE user_name = _user_name AND user_pwd = oldPwd;
	IF temp != 0 THEN
		UPDATE dt_user SET user_pwd = newPwd WHERE user_name = _user_name;
		SET result = '';
	END IF;
	SELECT result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classBegin
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classBegin`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classBegin`(
	_cls_id int,
	_cls_clsr_id int
)
BEGIN
		UPDATE `dt_classroom` SET `clsr_occupy` = 1 WHERE `clsr_id` = _cls_clsr_id;
		SET @cur_date = date_format(now(), '%Y-%m-%d');
		UPDATE `dt_class` SET `cls_clsr_id` = _cls_clsr_id, `cls_begin` = @cur_date WHERE `cls_id` = _cls_id;
		SELECT @cur_date as result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classEnd
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classEnd`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classEnd`(
	_cls_id int
)
BEGIN
		UPDATE `dt_classroom` SET `clsr_occupy` = 0 
		WHERE `clsr_id` = (SELECT `cls_clsr_id` FROM `dt_class` WHERE `cls_id` = _cls_id);
		SET @cur_date = date_format(now(), '%Y-%m-%d');
		UPDATE `dt_class` SET `cls_end` = @cur_date WHERE `cls_id` = _cls_id;
		SELECT @cur_date as result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classRetrieve`(
	_cls_name varchar(20),		
	_cls_dic_id_major int,	
	_cls_status int,
	_begin int,								
  _pageSize int							
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	
	IF _cls_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND cls_name LIKE ''%', _cls_name, '%''');
	END IF;

	IF _cls_dic_id_major != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND cls_dic_id_major = ', _cls_dic_id_major);
	END IF;

	-- SET @cur_date = date_format(now(), '%Y-%m-%d');

	IF _cls_status = 1 THEN					-- 查看开课中的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_begin is not NULL AND cls_end is NULL');
	ELSEIF _cls_status = 2 THEN 		-- 查看未开课的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_begin is NULL');
	ELSEIF _cls_status = 3 THEN			-- 查看结课的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_end is not NULL');
	ELSE														-- 查看所有班级
		SET @whereSql = CONCAT(@whereSql, ' AND 1 = 1');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_class ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_teacher) as cls_stf_name_teacher, 
			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_admin) as cls_stf_name_admin, 
			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_job) as cls_stf_name_job
	SET @selectSql = 'SELECT *, 
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_teacher`) as `cls_stf_id_teacher_name`,
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_admin`) as `cls_stf_id_admin_name` ,
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_job`) as `cls_stf_id_job_name` 
		FROM dt_class ';
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classUpdate
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classUpdate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classUpdate`(
	_cls_id int,	
	_cls_name varchar(20), 
	_cls_dic_id_major int, 
	_cls_clsr_id int, 
	_cls_stf_id_teacher int, 
	_cls_stf_id_admin int, 
	_cls_stf_id_job int, 
	_cls_begin varchar(10), 
	_cls_end varchar(10), 
	_cls_remark varchar(255)				
)
BEGIN
	DECLARE _cls_clsr_id_temp INT DEFAULT NULL; 
	IF _cls_clsr_id IS NOT NULL THEN
		SELECT cls_clsr_id INTO _cls_clsr_id_temp FROM dt_class WHERE cls_id = _cls_id;
	END IF;

	IF _cls_clsr_id_temp != _cls_clsr_id THEN
		UPDATE dt_classroom SET clsr_occupy = 0 WHERE clsr_id = _cls_clsr_id_temp;
		UPDATE dt_classroom SET clsr_occupy = 1 WHERE clsr_id = _cls_clsr_id;
	END IF;

	UPDATE dt_class 
	SET cls_name = _cls_name, 
			cls_dic_id_major = _cls_dic_id_major, 
			cls_clsr_id = _cls_clsr_id, 
			cls_stf_id_teacher = _cls_stf_id_teacher, 
			cls_stf_id_admin = _cls_stf_id_admin, 
			cls_stf_id_job = _cls_stf_id_job, 
			cls_begin = _cls_begin, 
			cls_end = _cls_end, 
			cls_remark = _cls_remark 
	WHERE cls_id = _cls_id;	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_configRoleFunction
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_configRoleFunction`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_configRoleFunction`(
	_role_id int,							-- 角色的id
	_func_ids varchar(50)		-- 多个功能id连成的字符串
)
BEGIN
	DECLARE _func_id varchar(10) DEFAULT '';
	-- 先删除角色原有的所有功能
	DELETE FROM `dt_role_function` WHERE `role_id` = _role_id;
	-- 逐个添加角色新的关联功能
	SET _func_id = substring_index(_func_ids, ',', 1);
	WHILE LENGTH(_func_id) > 0 DO
			INSERT INTO `dt_role_function`(`role_id`,`func_id`) VALUES(_role_id, CONVERT(_func_id, SIGNED));
			SET _func_ids = substring(_func_ids, length(_func_id) + 2);
			SET _func_id = substring_index(_func_ids, ',', 1);
	END WHILE;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_configUserRole
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_configUserRole`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_configUserRole`(
	_user_name varchar(20),		-- 用户名
	_role_id int							-- 角色分类id
)
BEGIN
	DELETE FROM `dt_user_role` WHERE `user_name` = _user_name;
	IF _role_id != 0 THEN
		INSERT INTO `dt_user_role`(`user_name`, `role_id`) VALUES(_user_name, _role_id);
	END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_getFunctionByRole
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_getFunctionByRole`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_getFunctionByRole`(
	_role_id int				-- 职位分类id
)
BEGIN
	IF _role_id = 0 THEN
		SELECT * FROM `dt_function`;
	ELSE
		SELECT T2.* 
		FROM (SELECT * FROM `dt_role_function` WHERE `role_id` = _role_id) T1 LEFT JOIN `dt_function` T2
		ON 	T1.func_id = T2.func_id;
	END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_getUserMenu
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_getUserMenu`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_getUserMenu`(
	_user_name varchar(20)
)
BEGIN
		DECLARE _role_id INT DEFAULT 0;
    # 根据用户名找到用户的角色id
		SELECT role_id INTO _role_id FROM dt_user_role WHERE user_name = _user_name;
		# 根据用户角色id找到其角色可以使用的所有功能
		SELECT T2.*
    FROM (SELECT func_id FROM dt_role_function WHERE role_id = _role_id) T1 
		LEFT JOIN dt_function T2 
		ON T1.func_id = T2.func_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_staffRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_staffRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_staffRetrieve`(
	_stf_category int,				-- 职位分类id
	_stf_name varchar(20),		-- 员工检索名字
	_begin int,								-- limit的offset
  _pageSize int							-- limit的rows
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	IF _stf_category != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T1.stf_category = ', _stf_category);
	END IF;
	IF _stf_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND T1.stf_name LIKE ''%', _stf_name, '%''');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_staff T1 ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

	SET @selectSql = 'SELECT T1.* FROM dt_staff T1 ';
	
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_studentRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_studentRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_studentRetrieve`(
	_stu_name varchar(20),		
	_stu_cls_id int,	
	_stu_qualification int,
	_begin int,								
  _pageSize int							
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	
	IF _stu_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND stu_name LIKE ''%', _stu_name, '%''');
	END IF;

	IF _stu_cls_id = 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND 1 = 1 ');
	ELSEIF _stu_cls_id IS NULL THEN
		SET @whereSql = CONCAT(@whereSql, ' AND stu_cls_id IS NULL ');
	ELSE
		SET @whereSql = CONCAT(@whereSql, ' AND stu_cls_id = ', _stu_cls_id);
	END IF;

	IF _stu_qualification != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND stu_qualification = ', _stu_qualification);
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_student ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

	SET @selectSql = 'SELECT * FROM dt_student ';
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_userRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_userRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_userRetrieve`(
	_user_name varchar(20),		-- 用户检索名字
	_role_id int,							-- 角色id
	_begin int,								-- limit的offset
  _pageSize int							-- limit的rows
)
BEGIN
	SET @fromSql = ' FROM dt_user T1 LEFT JOIN dt_user_role T2 ON T1.user_name = T2.user_name ';

	SET @whereSql = 'WHERE 1 = 1';
	IF _user_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND T1.user_name LIKE ''%', _user_name, '%''');
	END IF;

	IF _role_id > 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T2.role_id = ', _role_id);
	ELSEIF _role_id = 0  THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T2.role_id is NULL ');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total', @fromSql, @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;
	
	SET @selectSql = 'SELECT T1.*, T2.role_id';	
	SET @selectSql = CONCAT(@selectSql, @fromSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);
	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `t_afterinsert_on_student`;
DELIMITER ;;
CREATE TRIGGER `t_afterinsert_on_student` AFTER INSERT ON `dt_student` FOR EACH ROW BEGIN
     insert into dt_user(user_name,user_pwd) values(new.stu_phone, '123');
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `t_afterupdate_on_student`;
DELIMITER ;;
CREATE TRIGGER `t_afterupdate_on_student` AFTER UPDATE ON `dt_student` FOR EACH ROW BEGIN
        IF NEW.stu_phone != OLD.stu_phone THEN
              UPDATE dt_user SET user_name = NEW.stu_phone WHERE user_name = OLD.stu_phone;
        END IF;
END
;;
DELIMITER ;

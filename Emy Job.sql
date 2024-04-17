INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_yellow', 'yellow', 1);

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(null , 'society_yellow', 0, null);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_yellow', 'yellow', 1);

INSERT INTO `jobs` (`name`, `label`) VALUES
('yellow', 'yellow');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('yellow', 0, 'recrue', 'Barman', 0, '', ''),
('yellow', 1, 'offi1', 'Chef barman', 0, '', ''),
('yellow', 2, 'boss', 'Manager', 0, '', ''),
('yellow', 3, 'boss', 'Co patron', 0, '', ''),
('yellow', 4, 'boss', 'Patron', 0, '', '');
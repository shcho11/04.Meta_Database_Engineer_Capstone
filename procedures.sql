----------------
-- Procedures
----------------

----------------
-- (1) GetMaxQuantity
DROP PROCEDURE IF EXISTS `GetMaxQuantity`; 
CREATE PROCEDURE `GetMaxQuantity`()
SELECT max(quantity) AS `Max_Quantity` FROM Orders ; 
-- Call this Procedure
Call `littlelemon`.`GetMaxQuantity`();

----------------
-- (2) ManageBooking
DROP PROCEDURE IF EXISTS `ManageBooking`;
DELIMITER //
CREATE PROCEDURE `ManageBooking`(
    IN booking_id INT,
    IN booking_date DATE,
    IN table_number INT)

BEGIN
  DECLARE booking_count INT ;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    -- rollback the transaction when error occurs
    ROLLBACK;
    SELECT 'Error occurred! Transaction rolled back.' AS Status ;
  END;

  START TRANSACTION;

  -- 1. Check table already booked
  SELECT COUNT(*)
  INTO booking_count
  FROM Bookings
  WHERE `Date` = booking_date
  AND `TableNumber` = table_number
  AND `BookingID` <> booking_id;

  IF booking_count > 0 THEN
    ROLLBACK;
    SELECT CONCAT('Table ', table_number, 'is already booked for this date') AS Status;
  ELSE
    UPDATE Bookings
    SET `Date` = booking_date,
        `TableNumber` = table_number,
        `BookingID` = booking_id
    WHERE `BookingID` = booking_id;

    COMMIT;
    SELECT 'Booking Succesfully updated!' AS Status;
  END IF;
END;
//
DELIMITER ;
-- Call this Procedure
Call `littlelemon`.`ManageBooking`(11, '2023-09-02 21:00:00', 10);

----------------
-- (3) UpdateBooking
DROP PROCEDURE IF EXISTS `UpdateBooking`;
DELIMITER //
CREATE PROCEDURE `UpdateBooking`(
    IN booking_id INT,
    IN booking_date DATE)

BEGIN
UPDATE Bookings SET `Date` = booking_date WHERE `BookingID` = booking_id;
SELECT CONCAT("Booking", booking_id, "updated") AS `Update_Confirmed`;
END;
//
DELIMITER ;
-- Call this Procedure
Call `littlelemon`.`UpdateBooking`(10, '2023-09-06 20:00:00');

----------------
-- (4) AddBooking
DROP PROCEDURE IF EXISTS `AddBooking`;
DELIMITER //
CREATE PROCEDURE `AddBooking`(
    IN new_booking_id INT,
    IN new_booking_date DATE,
    IN new_table_number INT)

BEGIN
    -- Insert the new booking record
    INSERT INTO `Bookings`(
        `BookingID`,
        `Date`,
        `TableNumber`)
    VALUES(
        new_booking_id,
        new_booking_date,
        new_table_number
    );

    SELECT 'New booking added' AS `Add_Confirmed`;
END;
//
DELIMITER ;
-- Call this Procedure
Call `littlelemon`.`AddBooking`(11, '2023-09-06 21:00:00', 30);

----------------
-- (5) CancelBooking
DROP PROCEDURE IF EXISTS `CancelBooking`;
DELIMITER //
CREATE PROCEDURE `CancelBooking`(
    IN booking_id_to_cancel INT)

BEGIN
    -- Delete the booking record
    DELETE FROM `Bookings`
    WHERE `BookingID` = booking_id_to_cancel;

    SELECT CONCAT('Booking ', booking_id_to_cancel, ' cancelled') AS `Cancel_Confirmed`;
END;
//
DELIMITER ;
-- Call this Procedure
Call `littlelemon`.`CancelBooking`(11);

----------------
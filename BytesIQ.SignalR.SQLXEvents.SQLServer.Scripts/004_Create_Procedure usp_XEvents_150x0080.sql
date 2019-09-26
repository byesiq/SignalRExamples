USE [BytesIQ.SignalR.SQLXEvents]
GO

/****** Object:  StoredProcedure [db_xevents].[usp_XEvents_150x0080]    Script Date: 27/09/2019 00:00:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Bytes IQ
-- Create date: 2019-09-31
-- Description:	Raise XEvents 150 times at a rate of one every 80 milliseconds seconds,
-- output XEvent user_info as 'Stage X;Y' (X= Stage number, Y= Percentage complete)
-- =============================================
CREATE PROCEDURE [db_xevents].[usp_XEvents_150x0080]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intCounter int = 1,
	@intCounterMax int = 150,
	@event_class int = 85,
	@userinfo nvarchar(128),
	@userdata varbinary(400);

	SET @intCounter = 1
	SET @userinfo = CONCAT(N'Stage 0', ';', '0');
	SET @userdata = CAST(0 as varbinary(100));

	EXEC sp_trace_generateevent @event_class = @event_class, @userinfo = @userinfo, @userdata = @userdata;

	WHILE (@intCounter <= @intCounterMax)
	BEGIN
		set @userdata = CAST(@intCounter as varbinary(100));
		SET @userinfo = CONCAT(N'Stage ', @intCounter, ';', (CAST(100 as float)/CAST(@intCounterMax as float)) * CAST(@intCounter as float));
		WAITFOR DELAY '000:00:00:080'
		EXEC sp_trace_generateevent @event_class = @event_class, @userinfo = @userinfo, @userdata = @userdata; 
		SET @intCounter = @intCounter + 1
	END 
END
GO



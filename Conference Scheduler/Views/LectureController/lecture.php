<div class="row">
    <?php
    $lecture = $this->_viewBag['body'];
    if(true) :?>
        <div class="blueish panel panel-default col-md-12 margin-right">
            <div class="panel-body">
                <?php if (\Mvc\App::getInstance()->isLogged() && $_SESSION['role'] == 'site administrator') : ?>
                    <a class="margin-right float-right panel panel-danger col-sm-1 btn btn-default text-center"
                       href="/lecture/editLecture/<?= $lecture->getId() ?>/edit">Edit lecture</a>
                    <?php if($_SESSION['role'] == 'site administrator') : ?>
                        <a class="margin-right float-right panel panel-danger col-sm-1 btn btn-default text-center"
                           href="/lecture/removeLecture/<?= $lecture->getId() ?>/remove">Remove</a>
                    <?php endif; ?>
                <?php endif; ?>
                <div class="block">
                    <a class="panel panel-danger col-sm-4 btn btn-default text-center"
                       href="#"><?= $lecture->getName() ?></a>
                    <p>&nbsp;&nbsp;&nbsp;&nbsp;<i><?= $lecture->getDescription() ?></i></p>
                </div>
                <div class="block margin-top">
                    <p><b>Start date:</b> <?= date_format(date_create($lecture->getStart()), 'd F Y H:i')?></p>
                    <p><b>End date:</b> <?= date_format(date_create($lecture->getEnd()), 'd F Y H:i') ?></p>
                    <p><b>Speaker name:</b> <?= $lecture->getSpeaker() ?></p>
                    <p><b>Conference name:</b> <?= $lecture->getConference() ?></p>
                    <p><b>Hall name:</b> <?= $lecture->getHall() ?></p>

                </div>
            </div>
        </div>
    <?php endif; ?>
    ?>
</div>